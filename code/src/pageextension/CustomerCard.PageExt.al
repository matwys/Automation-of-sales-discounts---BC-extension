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
            field("Auto-assgined Disc. Expiration Date"; Rec."IMW Auto-ass. Disc.Exp.Date")
            {
                ApplicationArea = All;
                ToolTip = 'Ending Date Of Assigned To Discount Group';
                Editable = false;
                Visible = autoAssignCustDiscGroupBool;
            }
            field("Last Auto-assgined Changed By"; Rec."IMW Last Auto-ass.Changed By")
            {
                ApplicationArea = All;
                ToolTip = 'Last Auto-assgined Changed By';
                Editable = false;
                Visible = autoAssignCustDiscGroupBool;
            }
            field("Last Auto-assgined Changed Date"; Rec."IMW Last Auto-ass.Changed Date")
            {
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
        Rec."IMW Auto-ass. Disc.Exp.Date" := Today(); //+ SalesReceivablesSetup."IMW Period Of Validity";
        Rec."IMW Last Auto-ass.Changed Date" := Today;
        Update();
    end;
}