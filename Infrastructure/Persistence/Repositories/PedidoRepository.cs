using Application.Enums;
using Dapper;

namespace Infrastructure.Persistence.Repositories
{
    public class PedidoRepository : Application.Interfaces.Repositories.IPedidoRepository
    {
        public Application.DTOs.Output.Pedido Get(int id)
        {
            string queryOrder = "select a.*,b.nome as pedido_status  from pedido a inner join pedido_status b on b.id = a.pedido_status_id where a.id = @id";
            string queryOrderItem = @"select a.pedido_id,a.produto_id,a.preco_unitario,a.quantidade,b.nome as nome_produto from pedido_item a
            inner join produto b on b.id = a.produto_id  
            where pedido_id = @produto_id";

            string queryPaymnet = "select tipo_pagamento_id,pagamento_status_id from pedido_pagamento where pedido_id = @pedido_id";

            var order = Database.Connection().QueryFirstOrDefault<Application.DTOs.Output.Pedido>(queryOrder, new { id = id });
            if (order == null)
                return order;

            var orderItems = Database.Connection().Query<Application.DTOs.Output.PedidoItem>(queryOrderItem, new { pedido_id = order.Id });
            order.Itens = orderItems;

            var payment = Database.Connection().QueryFirstOrDefault(queryOrder, new { id = id });
            if (payment != null)
            {
                order.Pagamento = new Application.DTOs.Output.Pagamento
                {
                    TipoPagamento = (TipoPagamento)payment.tipo_pagamento_id,
                    StatusPagamento = payment.pagamento_status_id != null ? (PagamentoStatus)payment.pagamento_status_id : null
                };
            }

            return order;
        }

        public Application.DTOs.Output.PedidoPagamento GetPaymentStatus(int pedidoId)
        {
            string query = "select pedido_id,pagamento_status_id as status_pagamento from pedido_pagamento where pedido_id = @pedido_id";
            return Database.Connection().QueryFirstOrDefault<Application.DTOs.Output.PedidoPagamento>(query, new { pedido_id = pedidoId });
        }

        public IEnumerable<Application.DTOs.Output.Pedido> List()
        {
            string queryOrder = "select a.*,b.nome as pedido_status  from pedido a inner join pedido_status b on b.id = a.pedido_status_id where pedido_status_id <> 4 order by pedido_status_id desc, data";
            
            string queryOrderItem = @"select a.pedido_id,a.produto_id,a.preco_unitario,a.quantidade,b.nome as nome_produto from pedido_item a
            inner join produto b on b.id = a.produto_id  
            where pedido_id = any(@ids)";

            string queryPaymnet = "select pedido_id, tipo_pagamento_id,pagamento_status_id from pedido_pagamento where pedido_id = any(@ids)";

            var orders = Database.Connection().Query<Application.DTOs.Output.Pedido>(queryOrder);
            var orderItems = Database.Connection().Query<Application.DTOs.Output.PedidoItem>(queryOrderItem, new
            {
                ids = orders.Select(s => s.Id).ToList()
            });

            var payments = Database.Connection().Query(queryPaymnet, new
            {
                ids = orders.Select(s => s.Id).ToList()
            });


            orders.ToList().ForEach(order =>
            {
                order.Itens = orderItems.Where(w => w.PedidoId == order.Id);
            });

            orders.ToList().ForEach(order =>
            {
                var payment = payments.First(w => w.pedido_id == order.Id);
                order.Pagamento = new Application.DTOs.Output.Pagamento
                {
                    TipoPagamento = (TipoPagamento)payment.tipo_pagamento_id,
                    StatusPagamento = payment.pagamento_status_id != null ? (PagamentoStatus)payment.pagamento_status_id : null
                };
            });

            return orders;
        }

        public IEnumerable<Application.DTOs.Output.Pedido> ListByStatus(Domain.Enums.PedidoStatus status)
        {
            string queryOrder = "select a.*,b.nome as pedido_status  from pedido a inner join pedido_status b on b.id = a.pedido_status_id where pedido_status_id = @pedido_status_id";
            
            string queryOrderItem = @"select a.pedido_id,a.produto_id,a.preco_unitario,a.quantidade,b.nome as nome_produto from pedido_item a
            inner join produto b on b.id = a.produto_id  
            where pedido_id = any(@ids)";

            string queryPaymnet = "select pedido_id, tipo_pagamento_id,pagamento_status_id from pedido_pagamento where pedido_id = any(@ids)";

            var orders = Database.Connection().Query<Application.DTOs.Output.Pedido>(queryOrder, new { pedido_status_id = status });
            var orderItems = Database.Connection().Query<Application.DTOs.Output.PedidoItem>(queryOrderItem, new
            {
                ids = orders.Select(s => s.Id).ToList()
            });

            var payments = Database.Connection().Query(queryPaymnet, new
            {
                ids = orders.Select(s => s.Id).ToList()
            });


            orders.ToList().ForEach(order =>
            {
                order.Itens = orderItems.Where(w => w.PedidoId == order.Id);
            });

            orders.ToList().ForEach(order =>
            {
                var payment = payments.First(w => w.pedido_id == order.Id);
                order.Pagamento = new Application.DTOs.Output.Pagamento
                {
                    TipoPagamento = (TipoPagamento)payment.tipo_pagamento_id,
                    StatusPagamento = payment.pagamento_status_id != null ? (PagamentoStatus)payment.pagamento_status_id : null
                };
            });

            return orders;
        }

        public int Order(Domain.Entities.Pedido pedido)
        {
            string queryOrder = @"insert into pedido 
                                (cliente_id,anonimo,anonimo_identificador,pedido_status_id,valor,cliente_observacao,data) 
                                values 
                                (@cliente_id,@anonimo,@anonimo_identificador,@pedido_status_id,@valor,@cliente_observacao,now() AT TIME ZONE 'America/Sao_Paulo') RETURNING id";

            string queryOrderItem = @"insert into pedido_item 
                                    (pedido_id,produto_id,preco_unitario,quantidade) 
                                    values 
                                    (@pedido_id,@produto_id,@preco_unitario,@quantidade)";

            string queryPaymentInsert = "insert into pedido_pagamento (pedido_id,tipo_pagamento_id,valor,codigo_transacao,pagamento_status_id) values (@pedido_id,@tipo_pagamento_id,@valor,@codigo_transacao,@pagamento_status_id)";

            using (var connection = Database.Connection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    //Salva o pedido
                    int id = transaction.Connection.ExecuteScalar<int>(queryOrder, new
                    {
                        cliente_id = pedido.ClienteId,
                        anonimo = pedido.Anonimo,
                        anonimo_identificador = pedido.AnonimoIdentificador,
                        pedido_status_id = pedido.PedidoStatus,
                        valor = pedido.Valor,
                        cliente_observacao = pedido.ClienteObservacao
                    });
                    //Cria a lista de itens do pedido
                    var orderItems = pedido.Itens.Select(item => new
                    {
                        pedido_id = id,
                        produto_id = item.ProdutoId,
                        preco_unitario = item.PrecoUnitario,
                        quantidade = item.Quantidade
                    }).ToList();
                    //Salva os itens do pedido
                    transaction.Connection.Execute(queryOrderItem, orderItems);
                    //Salva dados de pagamento
                    transaction.Connection.Execute(queryPaymentInsert, new
                    {
                        pedido_id = id,
                        tipo_pagamento_id = pedido.Pagamento.TipoPagamentoId,
                        valor = pedido.Pagamento.Valor,
                        codigo_transacao = pedido.Pagamento.CodigoTransacao,
                        pagamento_status_id = pedido.Pagamento.PagamentoStatus
                    });

                    transaction.Commit();
                    connection.Close();
                    return id;
                }
            }
        }

        public bool UpdateOrderStatus(int pedidoId, Domain.Enums.PedidoStatus status)
        {
            string query = "update pedido set pedido_status_id = @pedido_status_id where id = @id";
            int affected = Database.Connection().Execute(query, new
            {
                id = pedidoId,
                pedido_status_id = status
            });

            return affected > 0;
        }

        public bool UpdatePaymentStatus(int pedidoId, Domain.Enums.PagamentoStatus status)
        {
            string query = "update pedido_pagamento set pagamento_status_id = @pagamento_status_id where pedido_id = @id";
            int affected = Database.Connection().Execute(query, new
            {
                id = pedidoId,
                pagamento_status_id = status
            });

            return affected > 0;
        }
    }
}
