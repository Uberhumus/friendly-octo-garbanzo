import pytest
from flask import Flask
from main import app, patents

# Test the patents function
def test_patents(mocker):
    mock_response = mocker.Mock()
    mock_response.json.return_value = {
        'results': [
            ["", "", "Patent Title 1"],
            ["", "", "Patent Title 2"],
        ]
    }
    mocker.patch('main.requests.get', return_value=mock_response)
    
    expected_titles = ["Patent Title 1", "Patent Title 2"]
    assert patents() == expected_titles

# Test the Flask route
def test_home_route(mocker):
    mock_response = mocker.Mock()
    mock_response.json.return_value = {
        'results': [
            ["", "", "Patent Title 1"],
            ["", "", "Patent Title 2"],
        ]
    }
    mocker.patch('main.requests.get', return_value=mock_response)

    client = app.test_client()
    response = client.get('/')
    assert response.status_code == 200
    assert b"Patent Title 1" in response.data
    assert b"Patent Title 2" in response.data
