using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Infrastructure.Payment.MercadoPago.Model
{
    public class WebhookNotification
    {
        public int id { get; set; }
        public bool live_mode { get; set; }

        [Required]
        [DefaultValue("payment.created")]
        public string type { get; set; } = "payment.created";
        public DateTime date_created { get; set; }
        public int user_id { get; set; }
        public string api_version { get; set; }
        public string action { get; set; }

        [Required]
        public WebhookNotificationData data { get; set; }

       
    }

    public class WebhookNotificationData
    {
        [Required]
        public int? pedido_id { get; set; }
    }
}
