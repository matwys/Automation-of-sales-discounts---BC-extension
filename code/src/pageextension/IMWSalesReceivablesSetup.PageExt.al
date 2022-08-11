pageextension 50001 "IMW Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group("IMW Auto Assigned Customer Discount Group")
            {
                Caption = 'Auto Assigned Customer Discount Group';
                field("IMW Auto-assign Cust.Disc.Gr."; Rec."IMW Auto Ass. Cust. Disc. Gr.")
                {
                    Caption = 'Auto Assigned Cust. Disc. Group';
                    ApplicationArea = All;
                    ToolTip = 'Turn on/turn of - Auto assigned customer discount group';


                    // trigger OnValidate()
                    // begin
                    //     if not Rec."IMW Auto Ass. Cust. Disc. Gr." then begin
                    //         if not Confirm(labelChangeAutoAssignedFromTrueQst) then
                    //             Rec."IMW Auto Ass. Cust. Disc. Gr." := true
                    //         else
                    //             Rec."IMW Status" := Rec."IMW Status"::Open;
                    //     end
                    //     else
                    //         if not Confirm(labelChangeAutoAssignedFromFalseQst) then
                    //             Rec."IMW Auto Ass. Cust. Disc. Gr." := false;

                    //     //autoAssignCustDiscGroupBool := Rec."IMW Auto-assign Cust.Disc.Gr.";
                    //     //CurrPage.Update(true);
                    // end;
                }
                field("IWM Turnover Period"; Rec."IMW Turnover Period")
                {
                    Caption = 'Turnover Period';
                    ApplicationArea = All;
                    ToolTip = 'Specifies time range for turnover period count';
                }
                field("IWM Period Of Validity"; Rec."IMW Period Of Validity")
                {
                    Caption = 'Period of Validity';
                    ApplicationArea = All;
                    ToolTip = 'Specifies time range for period of validity';
                }
                field("IMW Status"; Rec."IMW Status")
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Status of Requirements Auto-ass Disc. Group Page';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        // addafter(Payment)
        // {
        //     group("IMW Release Group")
        //     {
        //         Caption = 'Release';
        //         action("IMW Release")
        //         {
        //             Caption = 'Release';
        //             ApplicationArea = All;
        //             Image = ReleaseDoc;
        //             Enabled = Rec."IMW Status" <> Rec."IMW Status"::Released;
        //             ToolTip = 'Release the Requirements Auto-ass Disc. Group to the next stage of processing.';

        //             trigger OnAction()
        //             var
        //                 ReleaseOpenAssign: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
        //             begin
        //                 ReleaseOpenAssign.Release();
        //                 CurrPage.Update();
        //             end;
        //         }
        //         action("IMW Open")
        //         {
        //             Caption = 'Open';
        //             ApplicationArea = All;
        //             Image = ReOpen;
        //             Enabled = Rec."IMW Status" <> Rec."IMW Status"::"Open";
        //             ToolTip = 'Reopen the Requirements Auto-ass Disc. Group to change it after it has been approved.';

        //             trigger OnAction()
        //             var
        //                 ReleaseOpenAssign: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";
        //             begin
        //                 ReleaseOpenAssign.Open();
        //                 CurrPage.Update();
        //             end;
        //         }
        //     }
        // }
    }

    //var
    //autoAssignCustDiscGroupBool: Boolean;
    // labelChangeAutoAssignedFromTrueQst: Label 'Do you want to turn off? All auto-assigned values will lost validity.';
    // labelChangeAutoAssignedFromFalseQst: Label 'Do you want to turn on?';


    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        //autoAssignCustDiscGroupBool := SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr.";
    end;
}