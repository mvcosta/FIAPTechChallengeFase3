using Application.DTOs.External;
using System.Text;

namespace Infrastructure.Payment.MercadoPago
{
    public class MercadoPagoUseCase : Application.Interfaces.UseCases.IPaymentUseCase
    {
        /// <summary>
        /// Mock para envio de pagamento do Mercado Pago
        /// </summary>
        public PagamentoResponse ProcessPayment(PagamentoRequest request)
        {
            return new PagamentoResponse
            {
                CodigoTransacao = Guid.NewGuid().ToString(),
                Status = Domain.Enums.PagamentoStatus.Aprovado
            };


            using (HttpClient httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer YOUR_ACCESS_TOKEN");
                httpClient.DefaultRequestHeaders.Add("Content-Type", "application/json");

                // criado payload data
                var paymentInfo = new Model.PaymentInfoRequest
                {
                    additional_info = new Model.PaymentInfoRequest.AdditionalInfo { },
                    description = "teste",
                    external_reference = "",
                    installments = 1,
                    token = "token",
                    payer = new Model.PaymentInfoRequest.Payer()
                };
                
                var payload = System.Text.Json.JsonSerializer.Serialize(paymentInfo);
                var content = new StringContent(payload, Encoding.UTF8, "application/json");
                HttpResponseMessage response = httpClient.PostAsync("https://api.mercadopago.com/v1/payments", content).Result;

                // Handle the response
                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine("Successfully posted payment.");
                }
                else
                {
                    throw new Exception($"Failed to post payment: {response.StatusCode}");
                }
            }
        }

        public Application.Enums.PagamentoStatus? GetPaymentStatus(Model.WebhookNotification notification) 
        {
            if (notification.type == "payment.created" || notification.type == "payment.updated")
            {
                var payment = this.GetOrderPayment(Convert.ToInt32(notification.data.pedido_id));
                if (payment.status == "approved")
                    return Application.Enums.PagamentoStatus.Aprovado;
                else
                    return Application.Enums.PagamentoStatus.Recusado;
            }

            return null;
        }

        
        /// <summary>
        /// Mock para chamada de dados do pagamento no mercado Pago
        /// </summary>
        /// <param name="identifier"></param>
        Model.Payment GetOrderPayment(int identifier)
        {

            return new Model.Payment
            {
                status = "approved"
            };

            string accessToken = "access_token";
            string apiUrl = $"https://api.mercadopago.com/v1/payments/{identifier}";

            using (HttpClient httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Add("Authorization", $"Bearer {accessToken}");
                HttpResponseMessage response = httpClient.GetAsync(apiUrl).Result;
                if (response.IsSuccessStatusCode)
                {
                    return System.Text.Json.JsonSerializer.Deserialize<Model.Payment>(response.Content.ReadAsStringAsync().Result);
                }
                else
                {
                    throw new Exception($"Falha na chamada da API Mercado Pago: {response.StatusCode}");
                }
            }
        }
    }
}
