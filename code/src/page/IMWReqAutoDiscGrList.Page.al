page 50001 "IMW Req. Auto Disc. Gr. List"
{
    ApplicationArea = All;
    Caption = 'Requirements Auto Ass. Disc. Group Page';
    PageType = List;
    SourceTable = "IMW Req. Auto. Cust. Disc. Gr.";
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(Groups)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    Editable = SetupStatus;
                    ToolTip = 'Specifies a code for the customer discount group.';
                }
                field("Required"; Rec."Required")
                {
                    ApplicationArea = All;
                    Caption = 'Required';
                    Editable = SetupStatus;
                    ToolTip = 'Specifies a requirement for the customer discount group.';

                    trigger OnValidate()
                    var
                        ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
                    begin
                        ReqAutoAssDiscGroup.SetRange(Required, Rec."Required");
                        ReqAutoAssDiscGroup.SetFilter(Code, '<>%1', Rec.Code);
                        if ReqAutoAssDiscGroup.Count <> 0 then
                            Error(InvalideValueErr);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("IMW Release Group")
            {
                Caption = 'Release';
                action("IMW Release")
                {
                    ApplicationArea = All;
                    Caption = 'Release';
                    Enabled = SetupStatus;
                    Image = ReleaseDoc;
                    ToolTip = 'Release the Requirements Auto-ass Disc. Group to the next stage of processing.';

                    trigger OnAction()
                    var
                        ReleaseOpenAssign: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
                        SalesReceivablesSetup: Record "Sales & Receivables Setup";
                    begin
                        ReleaseOpenAssign.Release();
                        CurrPage.Update();

                        SalesReceivablesSetup.Get();
                        SetupStatus := false;
                        if SalesReceivablesSetup."IMW Status" <> SalesReceivablesSetup."IMW Status"::Released then
                            SetupStatus := true;
                    end;
                }
                action("IMW Open")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    Enabled = not SetupStatus;
                    Image = ReOpen;
                    ToolTip = 'Reopen the Requirements Auto-ass Disc. Group to change it after it has been approved.';

                    trigger OnAction()
                    var
                        ReleaseOpenAssign: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
                        SalesReceivablesSetup: Record "Sales & Receivables Setup";
                    begin
                        ReleaseOpenAssign.Open();
                        CurrPage.Update();

                        SalesReceivablesSetup.Get();
                        SetupStatus := false;
                        if SalesReceivablesSetup."IMW Status" <> SalesReceivablesSetup."IMW Status"::Released then
                            SetupStatus := true;
                    end;
                }
            }
        }
    }
    var
        SetupStatus: Boolean;
        InvalideValueErr: Label 'Invalide value.';

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SetupStatus := false;
        if SalesReceivablesSetup."IMW Status" <> SalesReceivablesSetup."IMW Status"::Released then
            SetupStatus := true;
    end;
}