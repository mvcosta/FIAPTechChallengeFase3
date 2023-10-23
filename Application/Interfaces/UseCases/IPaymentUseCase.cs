namespace Application.Interfaces.UseCases
{
    public interface IPaymentUseCase
    {
        public DTOs.External.PagamentoResponse ProcessPayment(DTOs.External.PagamentoRequest request);
    }
}
