namespace Infrastructure.Payment.MercadoPago.Model
{
    public class MPOrder
    {
        public string ExternalReference { get; set; }
        public decimal TotalAmount { get; set; }
        public List<Item> Items { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public SponsorClass Sponsor { get; set; }
        public DateTime ExpirationDate { get; set; }
        public string NotificationUrl { get; set; }

        public class Item
        {
            public string SkuNumber { get; set; }
            public string Category { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
            public string UnitMeasure { get; set; }
            public int Quantity { get; set; }
            public decimal UnitPrice { get; set; }
            public decimal TotalAmount { get; set; }
        }

        public class SponsorClass
        {
            public int Id { get; set; }
        }
    }
}
