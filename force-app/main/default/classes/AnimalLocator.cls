public class AnimalLocator {
    public static String getAnimalNameById(Integer animalId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + animalId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        String animalName = '';
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
             Map<string,object> animal = (Map<string,object>) result.get('animal');
            animalName = String.valueOf(animal.get('name'));
            System.debug('Received the following animals:' + animalName);
        }
        return animalName;
    }

}