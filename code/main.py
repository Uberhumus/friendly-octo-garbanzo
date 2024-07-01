import requests
import boto3
from botocore.exceptions import ClientError
from flask import render_template, Flask


base_url = 'https://api.nasa.gov/techtransfer/patent'
query = 'engine'


def get_secret():
    secret_name = "SuperSecretNASAToken2"
    region_name = "eu-west-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    return get_secret_value_response['SecretString']    


api_key = get_secret()


def patents():
    patent_titles = []
    response = requests.get('{}/?{}&api_key={}'.format(base_url, query, api_key))
    for result in response.json()['results']:
        patent_titles.append(result[2])

    return patent_titles


app = Flask(__name__)


@app.route('/', methods=['GET'])
def home():
    return render_template("index.html", data=patents())


def main():
    app.run(host='0.0.0.0', port=5001)


if __name__ == "__main__":
    main()