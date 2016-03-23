require 'sinatra'
require 'pry'

page = <<-EOM
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>File attachment form</title>
  </head>
  <script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function(event) {
      var form = document.forms[0];
      form.addEventListener('submit', function(ev) {

        var oOutput = document.querySelector("div"),
        oData = new FormData(form);

        var oReq = new XMLHttpRequest();
        oReq.open("POST", "/", true);
        oReq.onload = function(oEvent) {
          if (oReq.status == 200) {
            oOutput.innerHTML = "Uploaded!";
          } else {
            oOutput.innerHTML = "Error " + oReq.status + " occurred when trying to upload your file.<br \/>";
          }
        };

        oReq.send(oData);
        ev.preventDefault();
      }, false);
   });
  </script>
<body>
  <div />
  <p>The form below submits using JavaScript by getting the FormData object from the DOM and then making an XMLHttpRequest. On Firefox 45 this produces a bizarre request body if no file is selected.</p>
  <form method="post" enctype="multipart/form-data">
    <p>Attached File: <input type="file" name="attachment" size="128"></p>
    <p><input type="submit"></p>
  </form>
</body>
</html>
EOM
page.freeze

get '/' do
  [200, {}, page]
end

post '/' do
  logger.info("User-Agent: #{request.env['HTTP_USER_AGENT']}")
  logger.info("Params: ")
  Pry::ColorPrinter.pp(params, logger)
  200
end
