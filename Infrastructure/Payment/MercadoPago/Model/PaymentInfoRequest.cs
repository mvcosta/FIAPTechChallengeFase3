namespace Infrastructure.Payment.MercadoPago.Model
{
    public class PaymentInfoRequest
    {
        public AdditionalInfo additional_info { get; set; }
        public string description { get; set; }
        public string external_reference { get; set; }
        public int installments { get; set; }
        public object metadata { get; set; }
        public Payer payer { get; set; }
        public string payment_method_id { get; set; }
        public string token { get; set; }
        public double transaction_amount { get; set; }

        public class AdditionalInfo
        {
            public List<Item> items { get; set; }
            public Payer payer { get; set; }
            public Shipments shipments { get; set; }
        }

        public class Item
        {
            public string id { get; set; }
            public string title { get; set; }
        }

        public class Payer
        {
            public string first_name { get; set; }
            public string last_name { get; set; }
            public string email { get; set; }
            public Phone phone { get; set; }
            public Address address { get; set; }
        }

        public class Phone
        {
            public string area_code { get; set; }
            public string number { get; set; }
        }

        public class Address
        {
            // Address properties
        }

        public class Shipments
        {
            public ReceiverAddress receiver_address { get; set; }
        }

        public class ReceiverAddress
        {
            public string zip_code { get; set; }
        }
    }
}
