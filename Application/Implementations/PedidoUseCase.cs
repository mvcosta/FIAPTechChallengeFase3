using Application.Enums;
using Application.Interfaces.Repositories;
using Application.Interfaces.UseCases;

namespace Application.Implementations
{
    public class PedidoUseCase : Interfaces.UseCases.IPedidoUseCase
    {
        private readonly IPedidoRepository _pedidoRepository;
        private readonly IClienteRepository _clienteRepository;
        private readonly IProdutoRepository _produtoRepository;
        private readonly IPaymentUseCase _iPaymentUseCase;


        public PedidoUseCase(IPedidoRepository pedidoRepository,IClienteRepository clienteRepository, IProdutoRepository produtoRepository, IPaymentUseCase iPaymentUseCase)
        {
            this._pedidoRepository = pedidoRepository;
            this._clienteRepository = clienteRepository;
            this._produtoRepository = produtoRepository;
            this._iPaymentUseCase = iPaymentUseCase;
        }

        public DTOs.Output.Pedido Get(int id)
        {
            var result = this._pedidoRepository.Get(id);
            if (result == null)
                throw new CustomExceptions.NotFoundException("Pedido não encontrado");

            return result;
        }

        public Application.DTOs.Output.PedidoPagamento GetPaymentStatus(int pedidoId)
        {
            var result =  this._pedidoRepository.GetPaymentStatus(pedidoId);
            if(result == null)
                throw new CustomExceptions.NotFoundException($"Pedido não encontrado");

            return result;
        }

        public IEnumerable<DTOs.Output.Pedido> List()
        {
            return this._pedidoRepository.List();
        }

        public IEnumerable<DTOs.Output.Pedido> ListByStatus(PedidoStatus status)
        {
            return this._pedidoRepository.ListByStatus((Domain.Enums.PedidoStatus)status);
        }

        public DTOs.Output.PedidoIdentificador Order(DTOs.Imput.Pedido pedido)
        {
            if (pedido.ClienteId.HasValue && pedido.ClienteId.Value > 0)
            {
                var customerExists = _clienteRepository.Get(pedido.ClienteId.Value);
                if (customerExists == null)
                    throw new CustomExceptions.BadRequestException($"Cliente inválido");
            }

            var selectProducts = _produtoRepository.ListByIds(pedido.Itens.Select(s => s.ProdutoId.Value).ToList());
            var prodNotFound = pedido.Itens.Where(s => !selectProducts.Any(a => a.Id == s.ProdutoId)).ToList();
            if (prodNotFound.Count > 0)
            {
                throw new CustomExceptions.BadRequestException($"Produtos inválidos - Ids:[{string.Join(",", prodNotFound.Select(s => s.ProdutoId))}]");
            }

          
            //Busca os produtos do pedido para poder pegar os valores unitarios
            var products = _produtoRepository.List().Where(w => pedido.Itens.Select(s => s.ProdutoId).Any(a => a == w.Id)).ToList();
            //Cria a lista de itens para o request
            var itemsRequest = pedido.Itens.Select(s => 
                new Domain.Entities.PedidoItem(s.ProdutoId.Value, s.Quantidade.Value, products.FirstOrDefault(f => f.Id == s.ProdutoId).Preco));
            //Soma o total do pedido
            decimal totalValue = itemsRequest.Select(s => s.PrecoUnitario * s.Quantidade).Sum();


            //Cria o objeto de request
            var pedidoEntity = new Domain.Entities.Pedido(
                pedido.ClienteId,              
                Domain.Enums.PedidoStatus.Recebido,
                totalValue,
                pedido.ClienteObservacao,
                itemsRequest,
                new Domain.Entities.Pagamento(
                    (Domain.Enums.TipoPagamento)pedido.Pagamento.TipoPagamento,
                    pedido.Pagamento.Nome,
                    pedido.Pagamento.TokenCartao,
                    totalValue
                    ));

            //Chama o serviço de pagamento
            var paymentResult = this._iPaymentUseCase.ProcessPayment(new DTOs.External.PagamentoRequest
            {
                Nome = pedido.Pagamento.Nome,
                TipoPagamentoId = pedido.Pagamento.TipoPagamento,
                TokenCartao = pedido.Pagamento.TokenCartao,
                Valor = totalValue
            });
            //Atualiza o codigo da transação
            pedidoEntity.Pagamento.AtualizaCodigoTransacao(paymentResult.CodigoTransacao);
            //Atualiza status de pagamento
            pedidoEntity.Pagamento.AtualizaStatusPagamento(paymentResult.Status);

            //Salva no repositorio
            var identifier = _pedidoRepository.Order(pedidoEntity);

            return new DTOs.Output.PedidoIdentificador { Id = identifier }; 
        }

        public bool UpdateOrderStatus(int pedidoId, PedidoStatus status)
        {
            var result = _pedidoRepository.UpdateOrderStatus(pedidoId, (Domain.Enums.PedidoStatus)status);
            if(!result)
                throw new CustomExceptions.NotFoundException("Pedido não encontrado");

            return result;
        }

        public bool UpdatePaymentStatus(int id, PagamentoStatus status)
        {
            var result = _pedidoRepository.UpdateOrderStatus(id, (Domain.Enums.PedidoStatus)status);
            if (!result)
                throw new CustomExceptions.NotFoundException("Pedido não encontrado");

            return result;
        }
    }
}
