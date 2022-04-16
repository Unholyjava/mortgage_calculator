# mortgage_calculator

This application return properties of banks, monthly payment of current bank.
Also, application can set and update properties of banks,
delete current bank from list.

Front-part application is absent (I haven't learned this part yet),
so, this is Back-end part (http-server) made on Erlang/OTP.
Server is consist some checks for erroneous inputs.

Input and Output data are in json-format.

Specification of input data in http-requests is in file ./include/validate/validate_schemes.hrl
(required fields in request are marked 'required')

Application has initial data of banks in file ./config/sys.config

Application use native Erlang key-value storage - ets-table,
but can easily be converted to another database.

To try this application and have right view of XML-output,
you need any internet browser or command line with XML-output support.

To build the application use the following command:
$ make

To run the application use the following command:
$ make debug

Application can be testing by Postman at local server:
http://localhost:8080/api/v1/banks/get (GET-request),
http://localhost:8080/api/v1/banks/set (POST-request),
http://localhost:8080/api/v1/banks/update (POST-request),
http://localhost:8080/api/v1/banks/delete (POST-request),
http://localhost:8080/api/v1/payment/get (POST-request).


