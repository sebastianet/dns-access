program dns_lookup_project;

uses
  Vcl.Forms,
  dns_lookup_unit in 'dns_lookup_unit.pas' {fDNS};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfDNS, fDNS);
  Application.Run;
end.
