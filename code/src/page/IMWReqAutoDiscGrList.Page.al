page 50001 "IMW Req. Auto Disc. Gr. List"
{
    PageType = List;
    Caption = 'Requirements Auto Ass. Disc. Group Page';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "IMW Req. Auto. Cust. Disc. Gr.";


    layout
    {
        area(Content)
        {
            repeater(Groups)
            {
                field("Code"; Rec."Code")
                {
                    Caption = 'Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the customer discount group.';
                    Editable = SetupStatus;
                }
                field("Required"; Rec."Required")
                {
                    Caption = 'Required';
                    ApplicationArea = All;
                    ToolTip = 'Specifies a requirement for the customer discount group.';
                    Editable = SetupStatus;
                }
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //     }
    // }
    var
        SetupStatus: Boolean;

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