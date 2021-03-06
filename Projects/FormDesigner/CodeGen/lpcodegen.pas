unit lpcodegen;

{$mode objfpc}{$H+}

interface
  //The form code generator for LaPe interpreter by Cynic
uses
  Classes, SysUtils,sclist,AbstractCodeGen;

type

  { TLPCodeGen }

  TLPCodeGen = class(TAbstractCodeGen)
    public
     procedure GenerateScriptHeader;override;
     procedure GenerateProgressHeader;override;
     procedure CreateScript(list: TSimbaComponentList);override;
     Procedure GetComponentCode(smbl: TSimbaComponentList);override;
     Procedure SmbToCodeList(smb: TSimbaComponent;list: TStringList);override;
     Procedure GenerateFormCode(smbl: TSimbaComponentList);override;
     Procedure GenerateProgressCode(smbl: TSimbaComponentList);override;
     Procedure CreateFormCode(smb: TSimbaComponent;List: TStringList);override;
     function GetSimbaCType(smb: TSimbaComponent):integer;override;
     function GetScript(const List: TSimbaComponentList): TStrings;override;
  end;

implementation

{ TLPCodeGen }

procedure TLPCodeGen.GenerateScriptHeader;
var
 i: integer;
 s: string;
 b: integer;
begin
  b:=0;
HeaderCode.Add('var');
HeaderCode.Add(GenSpaces(2)+CmpList[0].compname+': TForm;');
HeaderCode.Add(GenSpaces(2)+'Font: TFont;');
if Labels.count> 0 then
  begin
  s:=GenSpaces(2);
  for i:=0 to labels.count -1 do
  begin
   if i<labels.Count-1 then
   s:=s+Labels[i].compname+','
    else
   s:=s+Labels[i].compname;
  end;
  i:=0;
  HeaderCode.Add(s+': TLabel;');
  end;
  if Edits.count> 0 then
  begin
  s:=GenSpaces(2);
  for i:=0 to Edits.count -1 do
  begin
   if i<Edits.Count-1 then
   s:=s+Edits[i].compname+','
    else
   s:=s+Edits[i].compname;
  end;
  i:=0;
  HeaderCode.Add(s+': TEdit;');
end;
  if Images.count> 0 then
  begin
  s:=GenSpaces(2);
  for i:=0 to Images.count -1 do
  begin
   if Images[i].img.switcher = true then inc(b);
   if i<Images.Count-1 then
   s:=s+Images[i].compname+','
    else
   s:=s+Images[i].compname
  end;
  i:=0;
  HeaderCode.Add(s+': TImage;');
end;
if Buttons.count> 0 then
  begin
  s:=GenSpaces(2);
  for i:=0 to Buttons.count -1 do
  begin
   if i<Buttons.Count-1 then
   s:=s+Buttons[i].compname+','
    else
   s:=s+Buttons[i].compname;
  end;
  i:=0;
  HeaderCode.Add(s+': TButton;');
end;
if CheckBoxes.count> 0 then
  begin
  s:=GenSpaces(2);
  for i:=0 to CheckBoxes.count -1 do
  begin
   if i<CheckBoxes.Count-1 then
   s:=s+CheckBoxes[i].compname+','
    else
   s:=s+CheckBoxes[i].compname;
  end;
  i:=0;
  HeaderCode.Add(s+': TCheckBox;');
end;
if ListBoxes.count> 0 then
  begin
  s:=GenSpaces(2);
  for i:=0 to ListBoxes.count -1 do
  begin
   if i<ListBoxes.Count-1 then
   s:=s+ListBoxes[i].compname+','
    else
   s:=s+ListBoxes[i].compname;
  end;
  i:=0;
  HeaderCode.Add(s+': TListBox;');
end;
if ComboBoxes.count> 0 then
  begin
  s:=GenSpaces(2);
  for i:=0 to ComboBoxes.count -1 do
  begin
   if i<ComboBoxes.Count-1 then
   s:=s+ComboBoxes[i].compname+','
    else
   s:=s+ComboBoxes[i].compname;
  end;
  i:=0;
  HeaderCode.Add(s+': TComboBox;');
end;
if RadBtns.count> 0 then
  begin
  s:=GenSpaces(2);
  for i:=0 to RadBtns.count -1 do
  begin
   if i<RadBtns.Count-1 then
   s:=s+RadBtns[i].compname+','
    else
   s:=s+RadBtns[i].compname;
  end;
  i:=0;
  HeaderCode.Add(s+': TRadioButton;');
end;
if img > 0 then
begin
 s:=GenSpaces(2);
  for i:=0 to img -1 do
  begin
   if i<img-1 then
   s:=s+'bmps'+inttostr(i)+','
    else
   s:=s+'bmps'+inttostr(i);
  end;
  i:=0;
  HeaderCode.Add(s+': TMufasaBitmap;');
end;
if img > 0 then
begin
 s:=GenSpaces(2);
  for i:=0 to img -1 do
  begin
   if i<img-1 then
   s:=s+'bmp'+inttostr(i)+','
    else
   s:=s+'bmp'+inttostr(i);
  end;
  i:=0;
  HeaderCode.Add(s+': integer;');
end;
with HeaderCode do
begin
  Add('');
  Add('const');
  Add(GenSpaces(2) + 'default = ' + #39 + 'New Times Roman' + #39 + ';');
  Add(GenSpaces(2) + 'clDefault = $20000000;');
  Add('');
  Add('procedure procedure_OnClick(sender: TObject);');
  Add('begin');
  Add(GenSpaces(2) + 'client.writeln(' + #39 + 'click' + #39 + ');');
  Add('end;');
end;
end;

procedure TLPCodeGen.GenerateProgressHeader;
begin

end;

procedure TLPCodeGen.CreateScript(list: TSimbaComponentList);
var
  i: integer;
  cmp: TSimbaComponent;
begin
  ResultScript.Clear;
  for i := 0 to list.Count - 1 do
  begin
    cmp := TSimbaComponent.Create;
    with cmp do
    begin
      clsname := list[i].clsname;
      compname := list[i].compname;
      caption := list[i].caption;
      fontcolor := list[i].fontcolor;
      fontname := list[i].fontname;
      img := list[i].img;
      height := list[i].height;
      width := list[i].width;
      left := list[i].left;
      top := list[i].top;
    end;
      CMPList.Add(Cmp);
  end;
  GenerateFormCode(CmpList);
  Stream.Position := 0;
  ResultScript.LoadFromStream(Stream);
end;

procedure TLPCodeGen.GetComponentCode(smbl: TSimbaComponentList);
var
  i, j: integer;
  smb, cmp: TSimbaComponent;
begin
  for i := 0 to smbl.count - 1 do
  begin
    smb := smbl[i];
    j := GetSimbaCType(smb);
    case j of
      0: CreateFormCode(smb, FormCode);
      1:
        begin
          SmbToCodeList(smb, LabelsCode);
          cmp := TSimbaComponent.Create;
          cmp.Assign(smb);
          Labels.Add(cmp);
        end;
      2:
        begin
          SmbToCodeList(smb, EditsCode);
          cmp := TSimbaComponent.Create;
          cmp.Assign(smb);
          Edits.Add(cmp);
        end;
      3:
        begin
          SmbToCodeList(smb, ImagesCode);
          cmp := TSimbaComponent.Create;
          cmp.Assign(smb);
          Images.Add(cmp);
        end;
      4:
        begin
          SmbToCodeList(smb, ButtonsCode);
          cmp := TSimbaComponent.Create;
          cmp.Assign(smb);
          Buttons.Add(cmp);
        end;
      5:
        begin
          SmbToCodeList(smb, CheckBoxesCode);
          cmp := TSimbaComponent.Create;
          cmp.Assign(smb);
          CheckBoxes.Add(cmp);
        end;
      6:
        begin
          SmbToCodeList(smb, ListBoxesCode);
          cmp := TSimbaComponent.Create;
          cmp.Assign(smb);
          ListBoxes.Add(cmp);
        end;
      7:
        begin
          SmbToCodeList(smb, ComboBoxesCode);
          cmp := TSimbaComponent.Create;
          cmp.Assign(smb);
          Comboboxes.Add(cmp);
        end;
      8:
        begin
          SmbToCodeList(smb, RadBtnsCode);
          cmp := TSimbaComponent.Create;
          cmp.Assign(smb);
          RadBtns.Add(cmp);
        end;
    end;
  end;
  GenerateScriptHeader;
end;

procedure TLPCodeGen.SmbToCodeList(smb: TSimbaComponent; list: TStringList);
var
  i,p,u: integer;
  s,s1,s2: string;//strings for bitmap;
begin
  i:=GetSimbaCtype(smb);
  Case i of
  1: begin
       list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
       list.Add(GenSpaces(2)+ smb.compname+'.Init('+cmpList[0].compname+');');
       list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
       list.Add(GenSpaces(2)+'begin');
       list.Add(GenSpaces(4)+'SetParent('+cmpList[0].compname+');');
       list.Add(GenSpaces(4)+'SetCaption('+#39+smb.caption+#39+');');
       list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
       list.Add(GenSpaces(4)+'Font := GetFont();');
       list.Add(GenSpaces(4)+'with Font do');
       list.Add(GenSpaces(4)+'begin');
       list.Add(GenSpaces(6)+'SetName('+smb.fontname+');');
       list.Add(GenSpaces(6)+'SetColor('+IntToStr(smb.fontcolor)+');');
       list.Add(GenSpaces(6)+'SetSize('+IntToStr(smb.fontsize)+');');
       list.Add(GenSpaces(4)+'end;');
       list.Add(GenSpaces(2)+'end;');
  end;
  2: begin
       list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
       list.Add(GenSpaces(2)+ smb.compname+'.Init('+cmpList[0].compname+');');
       list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
       list.Add(GenSpaces(2)+'begin');
       list.Add(GenSpaces(4)+'SetParent('+cmpList[0].compname+');');
       list.Add(GenSpaces(4)+'SetCaption('+#39+smb.caption+#39+');');
       list.Add(GenSpaces(4)+'SetText('+#39+'Input your text here!'+#39+');');
       list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
       list.Add(GenSpaces(4)+'Font := GetFont();');
       list.Add(GenSpaces(4)+'with Font do');
       list.Add(GenSpaces(4)+'begin');
       list.Add(GenSpaces(5)+'SetName('+smb.fontname+');');
       list.Add(GenSpaces(5)+'SetColor('+IntToStr(smb.fontcolor)+');');
       list.Add(GenSpaces(5)+'SetSize('+IntToStr(smb.fontsize)+');');
       list.Add(GenSpaces(4)+'end;');
       list.Add(GenSpaces(2)+'end;');
  end;
  3: begin
       s:=''; s1:=''; s2:='';
       list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
       list.Add(GenSpaces(2)+ smb.compname+'.Init('+cmpList[0].compname+');');
       list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
       list.Add(GenSpaces(2)+'begin');
       list.Add(GenSpaces(4)+'SetParent('+cmpList[0].compname+');');
       list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
       if smb.img.switcher = true then
         begin
          s:=smb.img.imgcode;
          if (smb.height<= 24) and (smb.width <=24) then
          begin
          s1:=#13#10+GenSpaces(4)+#39;
          for p:=0 to Length(s)-1 do begin
            SetLength(s1,Length(s1)+1);
            s1[Length(s1)]:=s[p+1];
            if p<>0 then begin
             if ((P/40)=trunc(P/40)) then
              begin
              SetLength(s1,Length(s1)+1);
              s1[Length(s1)]:=#39;
              SetLength(s1,Length(s1)+1);
              s1[Length(s1)]:='+';
              SetLength(s1,Length(s1)+1);
              s1[Length(s1)]:=#13;
              SetLength(s1,Length(s1)+1);
              s1[Length(s1)]:=#10;
              for u:=0 to 6 do
                 begin
                 SetLength(s1,Length(s1)+1);
                 s1[Length(s1)]:=#32;
                 end;
              SetLength(s1,Length(s1)+1);
              s1[Length(s1)]:=#39;
              end;
             if P = Length(s) then
              begin
              SetLength(s1,Length(s1)+1);
              s1[Length(s1)]:=#39;
              end;
            end;
            end;
          List.Add(GenSpaces(4)+'bmp'+IntToStr(img)+':=client.getMBitmaps().CreateBMPFromString('+IntToStr(smb.width)+','+IntToStr(smb.height)+','+s1+#39+');');
          List.Add(GenSpaces(4)+'bmps'+IntToStr(img)+':=client.getMBitmaps().GetBMP(bmp'+IntToStr(img)+');');
         // List.Add(GenSpaces(4)+'Picture.Bitmap.handle:=bmp'+IntToStr(img)+'.handle;');
          end else begin
          s2:=#39+s+#39;
        //  List.Add(GenSpaces(4)+'bmp'+IntToStr(img)+':=TBitmap.Create;');
          List.Add(GenSpaces(4)+'bmp'+IntToStr(img)+':=client.getMBitmaps().CreateBMPFromString('+IntToStr(smb.width)+','+IntToStr(smb.height)+','+s2+');');
          List.Add(GenSpaces(4)+'bmps'+IntToStr(img)+':=client.getMBitmaps().GetBMP(bmp'+IntToStr(img)+');');
          //List.Add(GenSpaces(4)+'Picture.Bitmap.handle:=bmp'+IntToStr(img)+'.handle;');
         // List.Add(GenSpaces(4)+'DrawBitmap(bmps'+IntToStr(img)+',Canvas,'+IntToStr(smb.width)+','+IntToStr(smb.height)+');');
         //list.Add(GenSpaces(4)+'Picture.Bitmap.LoadFromFile('+#39+smb.img.path+#39+');');
          end;
          List.Add(GenSpaces(4)+'bmps'+IntToStr(img)+'.DrawToCanvas(0,0,getCanvas());');
          List.Add(GenSpaces(4)+'client.getMBitmaps().RemoveBMP(bmp'+inttostr(img)+');');
         end else
       list.Add(GenSpaces(4)+'//'+'load bitmap to image here');
       list.Add(GenSpaces(2)+'end;');
       img:=img+1;
  end;
  4: begin
       list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
       list.Add(GenSpaces(2)+ smb.compname+'.Init('+cmpList[0].compname+');');
       list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
       list.Add(GenSpaces(2)+'begin');
       list.Add(GenSpaces(4)+'SetParent('+cmpList[0].compname+');');
       list.Add(GenSpaces(4)+'SetCaption('+#39+smb.caption+#39+');');
       list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
       list.Add(GenSpaces(4)+'SetOnClick(@procedure_OnClick);');
       list.Add(GenSpaces(4)+'Font := GetFont();');
       list.Add(GenSpaces(4)+'with Font do');
       list.Add(GenSpaces(4)+'begin');
       list.Add(GenSpaces(6)+'SetName('+smb.fontname+');');
       list.Add(GenSpaces(6)+'SetColor('+IntToStr(smb.fontcolor)+');');
       list.Add(GenSpaces(6)+'SetSize('+IntToStr(smb.fontsize)+');');
       list.Add(GenSpaces(4)+'end;');
       list.Add(GenSpaces(2)+'end;');

  end;
    5: begin
       list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
       list.Add(GenSpaces(2)+ smb.compname+'.Init('+cmpList[0].compname+');');
       list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
       list.Add(GenSpaces(2)+'begin');
       list.Add(GenSpaces(4)+'SetParent('+cmpList[0].compname+');');
       list.Add(GenSpaces(4)+'SetCaption('+#39+smb.caption+#39+');');
       //list.Add(GenSpaces(4)+'Checked:=false'+';');
       list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
       list.Add(GenSpaces(4)+'SetOnClick(@procedure_OnClick);');
       list.Add(GenSpaces(4)+'Font := GetFont();');
       list.Add(GenSpaces(4)+'with Font do');
       list.Add(GenSpaces(4)+'begin');
       list.Add(GenSpaces(6)+'SetName('+smb.fontname+');');
       list.Add(GenSpaces(6)+'SetColor('+IntToStr(smb.fontcolor)+');');
       list.Add(GenSpaces(6)+'SetSize('+IntToStr(smb.fontsize)+');');
       list.Add(GenSpaces(4)+'end;');
       list.Add(GenSpaces(2)+'end;');
  end;
    6: begin
       list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
       list.Add(GenSpaces(2)+ smb.compname+'.Init('+cmpList[0].compname+');');
       list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
       list.Add(GenSpaces(2)+'begin');
       list.Add(GenSpaces(4)+'SetParent('+cmpList[0].compname+');');
       list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
       list.Add(GenSpaces(4)+'//add your items here');
       list.Add(GenSpaces(4)+'GetItems().Add('+#39+'YourItem'+#39+')'+';');
       list.Add(GenSpaces(4)+'//End items');
       list.Add(GenSpaces(4)+'SetOnClick(@procedure_OnClick);');
       list.Add(GenSpaces(4)+'Font := GetFont();');
       list.Add(GenSpaces(6)+'with Font do');
       list.Add(GenSpaces(6)+'begin');
       list.Add(GenSpaces(6)+'SetName('+smb.fontname+');');
       list.Add(GenSpaces(6)+'SetColor('+IntToStr(smb.fontcolor)+');');
       list.Add(GenSpaces(6)+'SetSize('+IntToStr(smb.fontsize)+');');
       list.Add(GenSpaces(4)+'end;');
       list.Add(GenSpaces(2)+'end;');
  end;
    7: begin
       list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
       list.Add(GenSpaces(2)+ smb.compname+'.Init('+cmpList[0].compname+');');
       list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
       list.Add(GenSpaces(2)+'begin');
       list.Add(GenSpaces(4)+'SetParent('+cmpList[0].compname+');');
       list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
       list.Add(GenSpaces(4)+'//add your items here');
       list.Add(GenSpaces(4)+'GetItems().Add('+#39+'YourItem'+#39+')'+';');
       list.Add(GenSpaces(4)+'//End items');
       list.Add(GenSpaces(4)+'SetOnClick(@procedure_OnClick);');
       list.Add(GenSpaces(4)+'Font := GetFont();');
       list.Add(GenSpaces(4)+'with Font do');
       list.Add(GenSpaces(6)+'begin');
       list.Add(GenSpaces(6)+'SetName('+smb.fontname+');');
       list.Add(GenSpaces(6)+'SetColor('+IntToStr(smb.fontcolor)+');');
       list.Add(GenSpaces(6)+'SetSize('+IntToStr(smb.fontsize)+');');
       list.Add(GenSpaces(4)+'end;');
       list.Add(GenSpaces(2)+'end;');
  end;
  {  8: begin
       list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
       list.Add(GenSpaces(2)+ smb.compname+'.Init('+cmpList[0].compname+');');
       list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
       list.Add(GenSpaces(2)+'begin');
       list.Add(GenSpaces(4)+'SetParent('+cmpList[0].compname+');');
       list.Add(GenSpaces(4)+'SetCaption('+#39+smb.caption+#39+');');
       list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
       list.Add(GenSpaces(4)+'Font := GetFont();');
       list.Add(GenSpaces(4)+'with Font do');
       list.Add(GenSpaces(4)+'begin');
       list.Add(GenSpaces(6)+'SetName('+smb.fontname+');');
       list.Add(GenSpaces(6)+'SetColor('+IntToStr(smb.fontcolor)+');');
       list.Add(GenSpaces(6)+'SetSize('+IntToStr(smb.fontsize)+');');
       list.Add(GenSpaces(4)+'end;');
       list.Add(GenSpaces(2)+'end;');
  end;      }
end;

end;

procedure TLPCodeGen.GenerateFormCode(smbl: TSimbaComponentList);
begin
  GetComponentCode(smbl);
  with ScriptCode do
  begin
    AddStrings(HeaderCode);
    Add('');
    Add('procedure InitForm;');
    Add('begin');
    AddStrings(FormCode);
    if LabelsCode.Count > 0 then
      AddStrings(LabelsCode);
    if EditsCode.Count > 0 then
      AddStrings(EditsCode);
    if ImagesCode.Count > 0 then
      AddStrings(ImagesCode);
    if ButtonsCode.Count > 0 then
      AddStrings(ButtonsCode);
    if CheckBoxesCode.Count > 0 then
      AddStrings(CheckBoxesCode);
    if ListBoxesCode.Count > 0 then
      AddStrings(ListBoxesCode);
    if ComboBoxesCode.Count > 0 then
      AddStrings(ComboBoxesCode);
    {if RadBtnsCode.Count > 0 then //uncomment that when Simba will support TRadioButton
      AddStrings(RadBtnsCode);}
    Add(cmpList[0].compname+'.ShowModal;');
    Add('end;');
    Add('');
    Add('');
    Add('procedure FreeForm;');
    Add('begin');
    Add(GenSpaces(2)+'if ('+cmpList[0].compname+' = nil) then');
    Add(GenSpaces(4)+'exit();');
    Add('');
    Add(GenSpaces(2)+'client.writeln('+#39+'Freeing form...'+#39+');');
    Add(GenSpaces(2)+cmpList[0].compname+'.free;');
    Add('end;');
    Add('');
    Add('');
    Add('procedure ShowForm();');
    Add('begin');
    Add(GenSpaces(2) + 'try');
    Add(GenSpaces(4)+'sync(@InitForm);');
    Add(GenSpaces(2) + 'except');
    Add(GenSpaces(4) + 'writeln('+#39+'ERROR: Failed to initialize form'+#39+'); ');
    Add(GenSpaces(2)+'finally');
    Add(GenSpaces(4)+('sync(@FreeForm);'));
    Add(GenSpaces(2)+'end;');
    Add('end;');
    Add('');
    Add('begin');
    Add(GenSpaces(2) + 'ClearDebug(); ');
    Add(GenSpaces(2) + 'ShowForm();');
    Add('end.');
    SaveToStream(Stream);
  end;
end;

procedure TLPCodeGen.GenerateProgressCode(smbl: TSimbaComponentList);
begin

end;

procedure TLPCodeGen.CreateFormCode(smb: TSimbaComponent; List: TStringList);
 begin
  list.Add(GenSpaces(2)+'//'+smb.compname+'\\');
  list.Add(GenSpaces(2)+smb.compname+'.Init(nil);');
  list.Add(GenSpaces(2)+'with'+GenSpaces(1)+smb.compname+GenSpaces(1)+'do');
  list.Add(GenSpaces(2)+'begin');
  list.Add(GenSpaces(4)+'SetCaption('+#39+cmpList[0].caption+#39+');');
  list.Add(GenSpaces(4)+Format('SetBounds(%s,%s,%s,%s);',[IntToStr(smb.left),IntToStr(smb.top),IntToStr(smb.width),IntToStr(smb.height)]));
  list.Add(GenSpaces(4)+'SetPosition(poScreenCenter);');
  list.Add(GenSpaces(4)+'Font := GetFont();');
  list.Add(GenSpaces(4)+'with Font do');
  list.Add(GenSpaces(4)+'begin');
  list.Add(GenSpaces(6)+'SetName('+smb.fontname+');');
  list.Add(GenSpaces(6)+'SetColor('+IntToStr(smb.fontcolor)+');');
  list.Add(GenSpaces(6)+'SetSize('+IntToStr(smb.fontsize)+');');
  list.Add(GenSpaces(4)+'end;');
  list.Add(GenSpaces(2)+'end;');
 end;

function TLPCodeGen.GetSimbaCType(smb: TSimbaComponent): integer;
begin
  Result := -1;
   if CompareText(smb.clsname, 'TDsgnForm') = 0 then
    result:=0;
   if CompareText(smb.clsname, 'TLabel') = 0 then
    result:=1;
   if CompareText(smb.clsname, 'TEdit') = 0 then
    result:=2;
   if CompareText(smb.clsname, 'TImage') = 0 then
    result:=3;
   if CompareText(smb.clsname, 'TButton') = 0 then
    result:=4;
   if CompareText(smb.clsname, 'TCheckBox') = 0 then
    result:=5;
   if CompareText(smb.clsname, 'TListBox') = 0 then
    result:=6;
   if CompareText(smb.clsname, 'TComboBox') = 0 then
    result:=7;
   if CompareText(smb.clsname, 'TRadioButton') = 0 then
    result:=8;
end;

function TLPCodeGen.GetScript(const List: TSimbaComponentList): TStrings;
begin
  CreateScript(List);
  result:=ResultScript;
end;

end.

