program PasswordGrantDemo;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form2},
  REST.Authenticator.OAuth.PasswordGrant in 'REST.Authenticator.OAuth.PasswordGrant.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
