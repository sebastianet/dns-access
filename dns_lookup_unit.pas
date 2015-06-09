unit dns_lookup_unit;

// Command Line :
//  c:\Sebas\delphi\Ping_Continu> nslookup 91.126.241.136
//  Server:  UnKnown
//  Address:  192.168.1.1
//
//  Name:    cli-5b7ef188.bcn.adamo.es
//  Address:  91.126.241.136

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdDNSResolver, Vcl.StdCtrls, Vcl.ExtCtrls;

const
    kszIP    = '91.126.241.136' ;
    kszDNS   = '192.168.1.1' ; // 8.8.8.8 produces 1 result; 4.4.4.4 produces 0 results
    kTimeout = 3000 ;

type
  TfDNS = class(TForm)

    IdDNSResolver: TIdDNSResolver;
    btnDNS: TButton;
    edHN: TEdit;
    edIP: TEdit;
    lbEV: TListBox;
    timDNS: TTimer;
    procedure MyInit(Sender: TObject);

    procedure btnDNSClick(Sender: TObject);
    procedure timDNSTimeout(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  fDNS: TfDNS;


implementation

{$R *.dfm}

procedure debugMsg ( s:string ) ;
const
  kMaxNumofItems = 100 ;
  kNumItemstoDelete = 25 ;
var
  i : integer ;

begin

//  if not bLB_Trassa_Enabled then Exit ;

  with fDNS.lbEV do begin

    Items.add ( dateTimeToStr ( now ) + ' ' + s ) ;
      ItemIndex := Count - 1 ; // focus on last item
      ItemIndex := -1 ; // no focus

// delete if too many elements :
    if Items.Count > kMaxNumofItems then begin
      for i:=1 to kNumItemstoDelete do
        Items.Delete(0);
    end;

  end;
end; // debugMsg


// http://stackoverflow.com/questions/8277903/use-indy-to-perform-an-ipv6-reverse-dns-lookup

procedure ReverseDNSLookup( const IPAddress: String;
                            const DNSServer: String;
                            Timeout, Retries: Integer;
                            var szHostName: String ) ;

var
  AIdDNSResolver: TIdDNSResolver;
  RetryCount: Integer;
  iResultCount, iLng, i, iNew : integer ;
  chNew : char ;
  bResult : boolean ;

begin

  bResult := FALSE;

  AIdDNSResolver := TIdDNSResolver.Create(nil);

  try

    AIdDNSResolver.QueryResult.Clear;
    AIdDNSResolver.WaitingTime := Timeout;
    AIdDNSResolver.QueryType := [qtPTR];
    AIdDNSResolver.Host := DNSServer;

    RetryCount := Retries;

    repeat

      try

        dec( RetryCount );

        debugMsg ( '+++ call Resolver, IP ('+IPAddress+'), try ('+ IntToStr(RetryCount)+').' ) ;
        AIdDNSResolver.Resolve( IPAddress );

        Break;

      except

        on e: Exception do
        begin

          debugMsg ( '+++ Exception.' ) ;

          if RetryCount <= 0 then
          begin

 //           if SameText(e.Message, RSCodeQueryName) then
              bResult := FALSE ;
 //           else
 //             raise Exception.Create(e.Message);

            Break;
          end;
        end;
      end;
    until FALSE;

    iResultCount := AIdDNSResolver.QueryResult.Count ;
    debugMsg ( '+++ have ('+IntToStr(iResultCount)+') result(s).' ) ;
    bResult := AIdDNSResolver.QueryResult.Count > 0;

    if bResult then
    begin
      bResult := TRUE;
//      HostName := ParseReverseDNSResult( AIdDNSResolver.QueryResult[0].RData ) ;
      iLng := AIdDNSResolver.QueryResult[0].RDataLength ;
      debugMsg ( '+++ Result is of length ('+IntToStr(iLng)+').' ) ;
      i := 0 ;
      szHostname := '' ;

      while i < iLng do
      begin
        iNew := AIdDNSResolver.QueryResult[0].RData[i] ;
        if ( iNew > 32 ) then chNew := char ( iNew ) else chNew := '.' ; // skip control chars
        i := i + 1 ;
        szHostname := szHostname + chNew ;
      end;
//      szHostname := AIdDNSResolver.QueryResult[0].RData ;
      debugMsg ( '+++ Result is ('+ szHostname +').' ) ;

    end;
  finally
    FreeAndNil( AIdDNSResolver );
  end;
end; // ReverseDNSLookup


procedure TfDNS.timDNSTimeout(Sender: TObject);
var
  bRC : boolean ;
  szIP, szDNS, szHostname : string ;
  iTO, iRetry : integer ;

begin

  debugMsg ( '+++ do DNS lookup.' ) ;

  szIP := edIP.Text ;
  szDNS := kszDNS ;
  iTO := 3000 ;
  iRetry := 3 ;

  szHostname := '-' ;
  edHN.Text := szHostname ;

  ReverseDNSLookup( szIP, szDNS, iTO, iRetry, szHostname ) ;
  edHN.Text := szHostname ;

end; // timDNSTimeout


procedure TfDNS.btnDNSClick(Sender: TObject);
begin

  if timDNS.Enabled then
  begin
    timDNS.Enabled  := false ;
    btnDNS.Caption  := 'Start DNS lookup' ;
  end else
  begin
    timDNS.Interval := 1000 ;
    timDNS.Enabled  := true ;
    btnDNS.Caption  := 'Stop DNS lookup' ;
  end;

end; // btnDNSClick


procedure TfDNS.MyInit(Sender: TObject);
begin

  edIP.Text := kszIP ;
  debugMsg ( '+++ IP (' + edIP.Text + ').' ) ;

end; // MyInit


end.
