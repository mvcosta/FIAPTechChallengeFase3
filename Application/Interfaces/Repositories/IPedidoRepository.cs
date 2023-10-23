using Domain.Entities;

namespace Application.Interfaces.Repositories
{
    public interface IPedidoRepository
    {
        public IEnumerable<DTOs.Output.Pedido> List();
        public IEnumerable<DTOs.Output.Pedido> ListByStatus(Domain.Enums.PedidoStatus status);
        public DTOs.Output.Pedido Get(int id);
        public int Order(Pedido pedido);
        public bool UpdateOrderStatus(int id, Domain.Enums.PedidoStatus status);
        public Application.DTOs.Output.PedidoPagamento GetPaymentStatus(int pedidoId);
        public bool UpdatePaymentStatus(int id, Domain.Enums.PagamentoStatus status);
    }
}
