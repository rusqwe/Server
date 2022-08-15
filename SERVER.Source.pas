unit SERVER.Source;

interface

uses Generics.Collections, System.Types, REST.Json.Types, REST.Json;

type
  TSERVERCustomMessage = record
    success_message: string;
    errore_message: string;

  end;
  TSERVERMessage = class
  public
    success_message: string;
    errore_message: string;
    function AsJSON: string;
  end;

  TSERVERSource = class
    Id: integer;
    SName: string;
    DB: string;
    DBHost: string;
    DBNames: TStringDynArray;
    DBPort: string;
    Port: string;
    constructor Create;
  end;

implementation

{ TSERVERSource }

constructor TSERVERSource.Create;
begin
  DBNames := TStringDynArray.Create();
end;

{ TSERVERMessage }

function TSERVERMessage.AsJSON: string;
var
  JsonStr: string;
begin
  JsonStr := TJson.ObjectToJsonString(self);
  Result :=  JsonStr;

  //Test := TJson.JsonToObject<TTestJSON>(JsonStr);

end;


end.
