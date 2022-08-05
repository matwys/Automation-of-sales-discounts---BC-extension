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
            field("IMW Auto-ass. Disc.Exp.Date"; Rec."IMW Auto-ass. Disc.Exp.Date")
            {
                Caption = 'Auto-assgined Disc. Expiration Date';
                ApplicationArea = All;
                ToolTip = 'Ending Date Of Assigned To Discount Group';
                Editable = false;
                Visible = autoAssignCustDiscGroupBool;
            }
            field("IMW Last Auto-ass.Changed By"; Rec."IMW Last Auto-ass.Changed By")
            {
                Caption = 'Last Auto-assgined Changed By';
                ApplicationArea = All;
                ToolTip = 'Last Auto-assgined Changed By';
                Editable = false;
                Visible = autoAssignCustDiscGroupBool;
            }
            field("IMW Last Auto-ass.Changed Date"; Rec."IMW Last Auto-ass.Changed Date")
            {
                Caption = 'Last Auto-assgined Changed Date';
                ApplicationArea = All;
                ToolTip = 'Last Date Of Auto-assigned To Discount Group';
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
        autoAssignCustDiscGroupBool := SalesReceivablesSetup."IMW Auto-assign Cust.Disc.Gr.";
        Rec."IMW Auto-ass. Disc.Exp.Date" := CalcDate(SalesReceivablesSetup."IMW Period Of Validity", Today());
        Rec."IMW Last Auto-ass.Changed Date" := Today;
        Update();
    end;
}