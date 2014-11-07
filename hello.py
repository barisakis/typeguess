from flask import Flask
from flask import request
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello Abraham and Baris.!"

@app.route("/submit",methods=['GET', 'POST'] )
def respond():
    print(request)
    if request.method == "GET":
        return "please send a post"

    return str(request.form)
    
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
