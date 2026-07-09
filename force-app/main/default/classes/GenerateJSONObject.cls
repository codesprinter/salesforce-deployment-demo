public class GenerateJSONObject {
    public class Response {
        public List<String> skip_columns;
        public Integer row_count;
        public Integer status;
        public List<Row> rows;
    }

    public class Row {
        public String Firstname;
        public String Lastname;
        public String Categories;
        public String Mobile;
        public String Email_Clients;
        public String Zone;
        public String Chip_ID;
        public String SmartCard;
        public String Products;
        public String Dealer;
        public Datetime First_purchase_date;
        public Datetime Expiration_Date;
    }

    public static String generateJSON(Integer numItems) {
        Response response = new Response();
        response.skip_columns = new List<String>();
        response.row_count = numItems;
        response.status = 1;
        response.rows = new List<Row>();

        for (Integer i = 0; i < numItems; i++) {
            Row row = new Row();
            row.Firstname = 'First name ' + String.valueOf(i);
            row.Lastname = 'Last name ' + String.valueOf(i);
            row.Categories = null;
            row.Mobile = 'Mobile number ' + String.valueOf(i);
            row.Email_Clients = null;
            row.Zone = 'Zone ' + String.valueOf(i);
            row.Chip_ID = String.valueOf(i);
            row.SmartCard = 'SmartCard ' + String.valueOf(i);
            row.Products = 'Product ' + String.valueOf(i);
            row.Dealer = 'Dealer ' + String.valueOf(i);
            row.First_purchase_date = Datetime.newInstanceGmt(2015, 4, 30, 14, 34, 5);
            row.Expiration_Date = Datetime.newInstanceGmt(2023, 5, 20, 15, 31, 37);

            response.rows.add(row);
        }

        return JSON.serialize(response);
    }
}