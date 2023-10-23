using API.Validation;
using Microsoft.AspNetCore.Mvc;
using System.Reflection;
using static Infrastructure.Payment.MercadoPago.Model.WebhookNotification;

namespace API.Controllers
{
    [ApiController]
    [Route("PaymentWebhook")]
    public class PaymentWebhook : ControllerBase
    {
        private readonly Application.Interfaces.UseCases.IPedidoUseCase _pedidoUseCase;

        public PaymentWebhook(Application.Interfaces.UseCases.IPedidoUseCase pedidoUseCase)
        {
            this._pedidoUseCase = pedidoUseCase;
        }

        /// <summary>
        /// Retorna o status de pagamento de um pedido
        /// </summary>
        /// <param name="pedidoId">Id do pedido</param>
        /// <response code="404" >Pedido não encontrado</response>  
        [HttpPost]
        [Route("updatePaymentStatus")]
        [ProducesResponseType(typeof(bool), 200)]
        [CustonValidateModel]
        public ActionResult<bool> UpdatePaymentStatus(Infrastructure.Payment.MercadoPago.Model.WebhookNotification notification)
        {
            try
            {
                var payment = new Infrastructure.Payment.MercadoPago.MercadoPagoUseCase().GetPaymentStatus(notification);
                if (payment.HasValue)
                {
                    return Ok(_pedidoUseCase.UpdatePaymentStatus(notification.data.pedido_id.Value, (Application.Enums.PagamentoStatus)payment.Value));
                }
                else
                {
                    return NotFound("Pedido não encontrado");
                }
            }
            catch (Application.CustomExceptions.NotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
