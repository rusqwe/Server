unit SERVER.Source;

interface

uses Generics.Collections, System.Types;

type
  TSERVERSource = class
    Id: integer;
    SName: String;
    DB: String;
    DBHost: String;
    DBNames: TStringDynArray;
    DBPort: String;
    Port: String;
    constructor Create;
  end;

implementation

{ TSERVERSource }

constructor TSERVERSource.Create;
begin
  DBNames := TStringDynArray.Create();
end;

end.
