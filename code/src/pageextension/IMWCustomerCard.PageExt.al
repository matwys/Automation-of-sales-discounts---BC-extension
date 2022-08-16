pageextension 50002 "IMW Customer Card" extends "Customer Card"
{
    layout
    {
        modify("Customer Disc. Group")
        {
            Editable = NOT AutoAssignCustDiscGroupBool;
        }
        addafter("Customer Disc. Group")
        {
            field("IMW Auto. Ass. Disc. Valid To"; Rec."IMW Auto. Ass. Disc. Valid To")
            {
                Caption = 'Auto Assign Disc. To Disc. Valid To';
                ApplicationArea = All;
                ToolTip = 'Ending Date Of Valid Auto Assign To Disc. Group';
                Editable = false;
                Visible = AutoAssignCustDiscGroupBool;
            }
            field("IMW Last Auto. Ass. Ch. By"; Rec."IMW Last Auto. Ass. Ch. By")
            {
                Caption = 'Last Auto Assign To Disc. Group Changed By';
                ApplicationArea = All;
                ToolTip = 'Last Auto Assign To Disc. Group Changed By';
                Editable = false;
                Visible = AutoAssignCustDiscGroupBool;
            }
            field("IMW Last Auto Ass. Ch. Date"; Rec."IMW Last Auto Ass. Ch. Date")
            {
                Caption = 'Last Auto Assign To Disc. Group Changed Date';
                ApplicationArea = All;
                ToolTip = 'Last Auto Assign To Disc. Group Changed Date';
                Editable = false;
                Visible = AutoAssignCustDiscGroupBool;
            }
        }
    }

    actions
    {
        addafter("Sales Journal")
        {
            action("IMW Auto Ass. To Disc. Gr.")
            {
                Caption = 'Auto Assign To Disc. Group';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Enabled = not SetupStatus;
                Visible = AutoAssignCustDiscGroupBool;
                ToolTip = 'Auto Assign Customer to Discount Group by Balance.';

                trigger OnAction()
                var
                    AutoAssignDiscGrMgt: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";

                begin
                    AutoAssignDiscGrMgt.AutoAssingCustomerToDiscGroup(Rec);

                end;
            }
            action("History Auto Ass. To Disc. Gr.")
            {
                Caption = 'History Of Auto Assign To Disc. Group';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Visible = AutoAssignCustDiscGroupBool;
                ToolTip = 'View History About Auto Assign To Discount Group.';
                RunObject = Page "IMW A. Ass. Disc. Gr. Hi. List";
                RunPageLink = "Customer No." = FIELD("No.");
            }
        }
    }

    var
        AutoAssignCustDiscGroupBool: Boolean;
        SetupStatus: Boolean;

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";

    begin
        SalesReceivablesSetup.Get();
        SetupStatus := false;
        if SalesReceivablesSetup."IMW Status" <> SalesReceivablesSetup."IMW Status"::Released then
            SetupStatus := true;
        AutoAssignCustDiscGroupBool := SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr.";
        //Rec."IMW Auto. Ass. Disc. Exp. Date" := CalcDate(SalesReceivablesSetup."IMW Period Of Validity", Today());
        //Rec."IMW Last Auto Ass. Ch. Date" := Today;
        //Update();
    end;
}