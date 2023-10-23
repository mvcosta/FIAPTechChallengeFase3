namespace Application.DTOs.External
{
    public class PagamentoResponse
    {
        public string CodigoTransacao { get; set; }
        public Domain.Enums.PagamentoStatus Status { get; set; }
    }
}
