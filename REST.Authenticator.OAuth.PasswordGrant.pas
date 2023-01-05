unit REST.Authenticator.OAuth.PasswordGrant;

interface

uses
  REST.Client,
  REST.Consts,
  REST.Types,
  System.SysUtils,
  System.DateUtils,
  REST.Authenticator.OAuth;

type
  TOAuth2AuthenticatorPasswordGrant = class(TOAuth2Authenticator)
  private
    FPassword: string;
    FUsername: string;
  public
    procedure ChangePasswordToAccesToken;
  published
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property AccessToken;
    property RefreshToken;
    property AccessTokenEndpoint;

  end;

implementation

procedure TOAuth2AuthenticatorPasswordGrant.ChangePasswordToAccesToken;
var
  LClient: TRestClient;
  LRequest: TRESTRequest;
  LToken: string;
  LIntValue: int64;
begin


  LClient := TRestClient.Create(AccessTokenEndpoint);
  try
    LRequest := TRESTRequest.Create(LClient); // The LClient now "owns" the Request and will free it.
    LRequest.Method := TRESTRequestMethod.rmPOST;
    // LRequest.Client := LClient; // unnecessary since the client "owns" the request it will assign the client

    LRequest.AddAuthParameter('username', FUsername, TRESTRequestParameterKind.pkGETorPOST);
    LRequest.AddAuthParameter('password', FPassword, TRESTRequestParameterKind.pkGETorPOST);
    LRequest.AddAuthParameter('client_id', ClientID, TRESTRequestParameterKind.pkGETorPOST);
    LRequest.AddAuthParameter('client_secret', ClientSecret, TRESTRequestParameterKind.pkGETorPOST);
    LRequest.AddAuthParameter('grant_type', 'password', TRESTRequestParameterKind.pkGETorPOST);

    LRequest.Execute;

    if LRequest.Response.GetSimpleValue('access_token', LToken) then
      AccessToken := LToken;
    if LRequest.Response.GetSimpleValue('refresh_token', LToken) then
      RefreshToken := LToken;

    // detect token-type. this is important for how using it later
    if LRequest.Response.GetSimpleValue('token_type', LToken) then
      TokenType := OAuth2TokenTypeFromString(LToken);

    // if provided by the service, the field "expires_in" contains
    // the number of seconds an access-token will be valid
    if LRequest.Response.GetSimpleValue('expires_in', LToken) then
    begin
      LIntValue := StrToIntdef(LToken, -1);
      if (LIntValue > -1) then
        AccessTokenExpiry := IncSecond(Now, LIntValue)
      else
        AccessTokenExpiry := 0.0;
    end;

    // an authentication-code may only be used once.
    // if we succeeded here and got an access-token, then
    // we do clear the auth-code as is is not valid anymore
    // and also not needed anymore.
    if (AccessToken <> '') then
      AuthCode := '';
  finally
    LClient.DisposeOf;
  end;

end;

end.
