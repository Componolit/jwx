[![Build Status](https://travis-ci.org/Componolit/jwx.svg?branch=master)](https://travis-ci.org/Componolit/jwx)

JWX is a library for handling [JSON](https://www.json.org/) data and more. It
is implemented in the [SPARK](http://spark-2014.org) programming language and
has been proven to contain no runtime errors. As a result, JWX is particularly
suited for processing untrusted information.

In version 0.5.0 of JWX, parsing of Base64 (RFC 4648) data, JSON (RFC 8259)
documents, JSON Web Keys (JWK, RFC 7517) and limited support for JSON Web
Signatures (JWS, RFC 7515) and JSON Web Tokens (JWT, RFC 7519) is implemented.
In the future, JSON Web Encryption (JWE, RFC 7516) and potentially [JSON
Schema](http://json-schema.org) is anticipated.

JWX is available under the AGPLv3 license. For commercial licensing and support
mail to jwx@componolit.com.

# Examples

API documentation is available [here](doc/api/index.html).

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
      Put_Line ("Lat.: " & Get_Real (Result)'Img); -- 37.7668
   end if;
end JSON;
```

## Validating a JSON web token

```Ada
with Ada.Text_IO; use Ada.Text_IO;
with JWX.JWT; use JWX.JWT;
with JWX_Test_Utils;

procedure JWT is
   Tmp  : String := JWX_Test_Utils.Read_File ("tests/data/JWT_test_data.dat");
   Key  : String := JWX_Test_Utils.Read_File ("tests/data/HTTP_auth_key.json");
   Data : String := Tmp (Tmp'First .. Tmp'Last - 1);
   package J renames Standard.JWX.JWT;
   Result : J.Result_Type;
begin
   Result := J.Validate_Compact (Data     => Data,
                                 Key_Data => Key,
                                 Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                                 Issuer   => "https://cmpnlt-demo.eu.auth0.com/",
                                 Now      => 1528404620);
   if Result = Result_OK then
      Put_Line ("Token is valid");
   end if;
end JWT;
```

# Limitations

The following known limitations exist in JWX:

* While absence of runtime errors has been proven, no formal analysis for the stack usage exists
* Generation of Base64, JSON, JWS, JWT etc. is not supported (only validation)
* Unicode is not supported
* JWS and JWT only support HMAC-SHA256 (no other HMAC modes, RSA or ECDSA)
* JWS JSON serialization is not supported (only JWS compact serialization)
* Only the registered claims `iss`, `exp` and `aud` are supported
* No scopes or custom claims are supported

# Building

Check out JWX and build it:

```
$ git clone --recursive https://github.com/Componolit/jwx.git
$ cd jwx
$ make
```

To build the test cases, AUnit must be in your project path. To build an run
the tests do:

```
$ make test
```

# License

AGPLv3, see [LICENSE](LICENSE) file for details.

# Contact

jwx@componolit.com or through the issue tracker at https://github.com/Componolit/jwx
