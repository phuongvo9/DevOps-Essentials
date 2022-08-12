from flask import Flask, jsonify
from werkzeug.wrappers import response

app=Flask(__name__)
@app.route("/baseimages",methods=['GET'])
def baseimages():
    response={
        "java": {
               "8": "openjdk:8-jdk-alpine",
               "11": "openjdk"
           },
        "python": {
            "36" : "centos/python-36-centos7",
            "38" : "centos/python-38-centos7"
        }
    }
    response = jsonify(response)
    response.status_code = 200
    return response

@app.route("/secrets", methods=['GET'])
def secrets():
    data={
        "secrets": {
            "remoteServerCreds": {
                "user": "ec2-user",
                "pass" : "ec2-user@123"
            },
            "awsAccessKeys" : {
                "aws_access_key_id": "LIVEARET45LJASDF9EWR",
                "aws_secret_access_key": "4GAbEcDDDeyYRNO4WBrnYeWgVa-YTDrV6GIJMqQabc"
            }       
        }
    }
    response = jsonify(data)
    response.status_code = 200
    return response
app.run(host="0.0.0.0", port=8080)