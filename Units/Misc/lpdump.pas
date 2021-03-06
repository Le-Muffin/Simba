unit LPDump;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, lpcompiler, lptypes, lpvartypes, lpparser, lptree;

type
  TLPCompiler = class(TLapeCompiler)
  private
    FItems: TStringList;
  public
    constructor Create(
      ATokenizer: TLapeTokenizerBase; ManageTokenizer: Boolean = True;
      AEmitter: TLapeCodeEmitter = nil; ManageEmitter: Boolean = True
    ); override;
    destructor Destroy; override;

    function addGlobalVar(AVar: TLapeGlobalVar; AName: lpString = ''): TLapeGlobalVar; override;
    function addGlobalVar(Typ: lpString; Value: lpString; AName: lpString): TLapeGlobalVar; override;
    function addGlobalType(Typ: TLapeType; AName: lpString = ''; ACopy: Boolean = True): TLapeType; override;
    function addGlobalType(Str: lpString; AName: lpString): TLapeType; override;
    function addGlobalFunc(AHeader: lpString; Value: Pointer): TLapeGlobalVar; override;
    function addDelayedCode(ACode: lpString; AFileName: lpString = ''; AfterCompilation: Boolean = True; IsGlobal: Boolean = True): TLapeTree_Base; override;
    procedure getInfo(aItems: TStrings);
  end;

implementation

uses
  lpeval;

function AddTrailingSemiColon(x: string): string;
begin
  Result := Trim(x);
  if (Result <> '') and (Result[Length(Result)] <> ';') then
    Result += ';';
end;

constructor TLPCompiler.Create(ATokenizer: TLapeTokenizerBase; ManageTokenizer: Boolean = True; AEmitter: TLapeCodeEmitter = nil; ManageEmitter: Boolean = True);
begin
  FItems := TStringList.Create();

  inherited Create(ATokenizer, ManageTokenizer, AEmitter, ManageEmitter);
end;

destructor TLPCompiler.Destroy;
begin
  FItems.Free();

  inherited;
end;

function TLPCompiler.addGlobalVar(AVar: TLapeGlobalVar; AName: lpString = ''): TLapeGlobalVar;
begin
  Result := inherited;
  if (Length(AName) > 0) and (AName[1] <> '!') and (AVar.BaseType in LapeOrdinalTypes-LapeOrdinalTypes+LapeRealTypes+LapeStringTypes+LapeSetTypes) then
    FItems.Add('const ' + AName + ': ' + AVar.VarType.AsString + ' = ' + AVar.AsString + ';');
end;

function TLPCompiler.addGlobalVar(Typ: lpString; Value: lpString; AName: lpString): TLapeGlobalVar;
begin
  Result := inherited;
  if (Length(AName) > 0) and (AName[1] <> '!') and (Lowercase(AName) <> Lowercase(Typ)) then
    if (Value <> '') then
      FItems.Add('const ' + AName + ': ' + Typ + ' = ' + Value + ';')
    else
      FItems.Add('var ' + AName + ': ' + Typ + ';');
end;

function TLPCompiler.addGlobalType(Typ: TLapeType; AName: lpString = ''; ACopy: Boolean = True): TLapeType;
begin
  Result := inherited;
  if (Length(AName) > 0) and (AName[1] <> '!') and (Lowercase(AName) <> Lowercase(Typ.Name)) then
    FItems.Add('type ' + AName + ' = ' + Typ.Name + ';');
end;

function TLPCompiler.addGlobalType(Str: lpString; AName: lpString): TLapeType;
begin
  Result := inherited;
  if (Length(AName) > 0) and (AName[1] <> '!') and (Lowercase(AName) <> Lowercase(Str)) then
    FItems.Add('type ' + AName + ' = ' + AddTrailingSemiColon(Str));
end;

function TLPCompiler.addGlobalFunc(AHeader: lpString; Value: Pointer): TLapeGlobalVar;
begin
  Result := inherited;
  if (Length(Result.Name) = 0) or (Result.Name[1] <> '_') then
    FItems.Add(AddTrailingSemiColon(AHeader) + ' forward;');
end;

function TLPCompiler.addDelayedCode(ACode: lpString; AFileName: lpString = ''; AfterCompilation: Boolean = True; IsGlobal: Boolean = True): TLapeTree_Base;
begin
  Result := inherited;
  if (AFileName <> '!addDelayedCore') then
    FItems.Add(ACode);
end;

procedure TLPCompiler.getInfo(aItems: TStrings);
var
  i: Integer;
begin
  aItems.Clear();
  aItems.addStrings(FItems);

  // Add magic Lape methods.
  // We cannot automate getting parameter/result information for now,
  // but we can link to documentation.
  for i := 0 to InternalMethodMap.Count - 1 do
    if (InternalMethodMap.Key[i] <> 'GOTO') and
       (InternalMethodMap.Key[i] <> 'LABEL') and
       (InternalMethodMap.Key[i] <> 'RAISE')
    then
      aItems.Add('procedure ' + InternalMethodMap.Key[i] + '(); forward;');
end;

end.

