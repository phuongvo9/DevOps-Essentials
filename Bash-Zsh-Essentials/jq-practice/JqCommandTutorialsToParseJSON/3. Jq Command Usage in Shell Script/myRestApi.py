from flask import Flask, jsonify
from werkzeug.wrappers import response

app=Flask(__name__)

@app.route("/secrets", methods=['GET'])
def secrets():
    data={
        "secrets": {
            "remoteServerCreds": {
                "userName": "ec2-user",
                "password" : "ec2-user@123"
            },
            "awsAccessKeys" : {
                "aws_access_key_id": "...",
                "aws_secret_access_key": "..."
            }       
        }
    }
    response = jsonify(data)
    response.status_code = 200
    return response
app.run(host="0.0.0.0", port=8080)