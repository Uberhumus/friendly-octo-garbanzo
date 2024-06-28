import requests
from flask import render_template, Flask

base_url = 'https://api.nasa.gov/techtransfer/patent'
query = 'engine'
api_key = 'DEMO_KEY'


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