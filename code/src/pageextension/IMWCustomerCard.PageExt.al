pageextension 50002 "IMW Customer Card" extends "Customer Card"
{
    layout
    {
        modify("Customer Disc. Group")
        {
            Editable = NOT autoAssignCustDiscGroupBool;
        }
        addafter("Customer Disc. Group")
        {
            field("IMW Auto Ass. Disc. Exp. Date"; Rec."IMW Auto. Ass. Disc. Exp. Date")
            {
                Caption = 'Auto Assgined Disc. Expiration Date';
                ApplicationArea = All;
                ToolTip = 'Ending Date Of Assigned To Discount Group';
                Editable = false;
                Visible = autoAssignCustDiscGroupBool;
            }
            field("IMW Last Auto Ass. Changed By"; Rec."IMW Last Auto. Ass. Ch. By")
            {
                Caption = 'Last Auto Assgined Changed By';
                ApplicationArea = All;
                ToolTip = 'Last Auto Assgined Changed By';
                Editable = false;
                Visible = autoAssignCustDiscGroupBool;
            }
            field("IMW Last Auto Ass. Changed Date"; Rec."IMW Last Auto Ass. Ch. Date")
            {
                Caption = 'Last Auto Assgined Changed Date';
                ApplicationArea = All;
                ToolTip = 'Last Date Of Auto Assigned To Discount Group';
                Editable = false;
                Visible = autoAssignCustDiscGroupBool;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        autoAssignCustDiscGroupBool: Boolean;

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        autoAssignCustDiscGroupBool := SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr.";
        Rec."IMW Auto. Ass. Disc. Exp. Date" := CalcDate(SalesReceivablesSetup."IMW Period Of Validity", Today());
        Rec."IMW Last Auto Ass. Ch. Date" := Today;
        Update();
    end;
}