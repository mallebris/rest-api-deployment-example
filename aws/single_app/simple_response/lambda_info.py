def lambda_handler(event, context):
    message = 'Hello this is a static response for TMNL assesment In order to use this consider send a POST request.Example: `curl -XPOST https://hlqkivf6gk.execute-api.us-east-2.amazonaws.com/assessment/ -d \'{\"message\": \"ing\"}\'`'
    return message