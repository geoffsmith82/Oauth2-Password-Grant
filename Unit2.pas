unit Unit2;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  REST.Types,
  REST.Client,
  REST.Authenticator.OAuth,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  REST.Authenticator.OAuth.PasswordGrant
  ;

type
  TForm2 = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAuthenticator : TOAuth2AuthenticatorPasswordGrant;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FAuthenticator);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FAuthenticator := TOAuth2AuthenticatorPasswordGrant.Create(nil);
  RESTClient1.Authenticator := FAuthenticator;
  FAuthenticator.AccessTokenEndpoint := '<token-endpoint-goes-here>';
  FAuthenticator.Username := '<username-goes-here>';
  FAuthenticator.Username := '<password-goes-here>';

  // Need to call FAuthenticator.ChangePasswordToAccesToken; somewhere before making requests

end;

end.
