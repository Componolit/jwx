**This is a preview of the JWX library which is under active development.**.

JWX is a library for handling [JSON](https://www.json.org/) data. It is
implemented in the [SPARK](http://spark-2014.org) programming language which
can be used to show the absence of runtime errors. As a result, JWX is
particularly suited for processing untrusted information.

In the current version, parsing of Base64 (RFC 4648) data, JSON (RFC 8259)
documents, JSON Web Keys (JWK, RFC 7517) and limited support for JSON Web
Signatures (JWS, RFC 7515) and JSON Web Tokens (JWT, RFC 7519) is implemented.
In the future, JSON Web Encryption (JWE, RFC 7516) and potentially [JSON
Schema](http://json-schema.org) is anticipated.

# Examples

## Parsing Base64 data

```Ada
with Ada.Text_IO; use Ada.Text_IO;
with JWX.Util;
with JWX.Base64;

procedure B64 is
   use JWX;
   Len    : Natural;
   Bytes  : Byte_Array (1..50);
   Result : String (1..50);
begin
   Base64.Decode (Encoded => "Zm9vYmFy", Length => Len, Result => Bytes);
   if Len > 0 then
      Util.To_String (Bytes, Result);
      Put_Line (Result (1 .. Len)); -- "foobar"
   end if;
end B64;
```

## Parsing JSON document

```Ada
with Ada.Text_IO; use Ada.Text_IO;
with JWX.JSON;

procedure JSON is
   Data : String := " { ""precision"": ""zip"", ""Latitude"":  37.7668, ""Longitude"": -122.3959, ""Address"": """", ""City"": ""SAN FRANCISCO"", ""State"": ""CA"", ""Zip"": ""94107"", ""Country"": ""US"" }";
   package J is new JWX.JSON (Data);
   use J;
   Result : Index_Type;
   Match : Match_Type;
begin
   Parse (Match);
   if Match = Match_OK and then Get_Kind = Kind_Object
   then
      Result := Query_Object ("City");
      Put_Line ("City: " & Get_String (Result)); -- "SAN FRANCISCO"

      Result := Query_Object ("Latitude");
      Put_Line ("Lat.: " & Get_Float (Result)'Img); -- 37.7668
   end if;
end JSON;
```

## Validating a JSON web token

```Ada
with Ada.Text_IO; use Ada.Text_IO;
with JWX.JWT;
with JWX_Test_Utils;

procedure JWT is
   Tmp  : String := JWX_Test_Utils.Read_File ("tests/data/JWT_test_data.dat");
   Key  : String := JWX_Test_Utils.Read_File ("tests/data/HTTP_auth_key.json");
   Data : String := Tmp (Tmp'First .. Tmp'Last - 1);

   package J is new JWX.JWT (Data     => Data,
                             Key_Data => Key,
                             Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                             Issuer   => "https://cmpnlt-demo.eu.auth0.com/",
                             Now      => 1528404620);
   use J;
   Result : Result_Type;
begin
   Validate_Compact (Result => Result);
   if Result = Result_OK then
      Put_Line ("Token is valid");
   end if;
end JWT;
```

# Limitations

The following known limitations exist in JWX:

* The code is valid SPARK, but absence of runtime errors is still to be proven
* Generation of Base64, JSON, JWS, JWT etc. is not supported (only validation)
* JWS and JWT only support HMAC-SHA256 (no other HMAC modes, RSA or ECDSA)
* JWS JSON serialization is not supported (only JWS compact serialization)
* Only the registered claims `iss`, `exp` and `aud` are supported
* No scopes or custom claims are supported
* No proper API documentation exists

# Building

To build JWX, [libsparkcrypto](https://github.com/Componolit/libsparkcrypto) is
required. Check out the `componolit` branch and install the library to a local
destination (we assume this is `${LIBSPARKCRYPTO_INSTALL_PATH}`):

```
$ cd ${LIBSPARKCRYPTO_DIR}
$ make DESTDIR=${LIBSPARKCRYPTO_INSTALL_PATH} NO_TESTS=1 NO_SPARK=1 SHARED=1 install
```

Then, check out JWX and build it:

```
$ cd ${JWX_DIR}
$ ADA_PROJECT_PATH=${LIBSPARKCRYPTO_INSTALL_PATH} make
```

To build the test cases, AUnit must be in your project path. To build an run
the tests do:

```
$ ADA_PROJECT_PATH=${LIBSPARKCRYPTO_INSTALL_PATH} make test
```

# License

AGPLv3, see `LICENSE` file for details.

# Contact

jwx@componolit.com or through the issue tracker at https://github.com/Componolit/jwx
