pageextension 50002 "IMW Customer Card" extends "Customer Card"
{
    layout
    {
        modify("Customer Disc. Group")
        {
            Editable = NOT AACustDiscGroupEnable;
        }
        addafter("Customer Disc. Group")
        {
            field("IMW AA Disc. Valid To"; Rec."IMW AA Disc. Valid To")
            {
                Caption = 'Auto Assign Disc. To Disc. Valid To';
                ApplicationArea = All;
                ToolTip = 'Ending Date Of Valid Auto Assign To Disc. Group';
                Editable = false;
                Visible = AACustDiscGroupEnable;
            }
            field("IMW Last AA Ch. By"; Rec."IMW Last AA Ch. By")
            {
                Caption = 'Last Auto Assign To Disc. Group Changed By';
                ApplicationArea = All;
                ToolTip = 'Last Auto Assign To Disc. Group Changed By';
                Editable = false;
                Visible = AACustDiscGroupEnable;
            }
            field("IMW Last AA Ch. Date"; Rec."IMW Last AA Ch. Date")
            {
                Caption = 'Last Auto Assign To Disc. Group Changed Date';
                ApplicationArea = All;
                ToolTip = 'Last Auto Assign To Disc. Group Changed Date';
                Editable = false;
                Visible = AACustDiscGroupEnable;
            }
        }
    }

    actions
    {
        //addafter("Prices and Discounts Overview")
        addlast("Prices and Discounts")
        {
            action("IMW AA To Disc. Gr.")
            {
                Caption = 'Auto Assign To Disc. Group';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Enabled = not SetupStatus;
                Visible = AACustDiscGroupEnable;
                ToolTip = 'Auto Assign Customer to Discount Group by Balance.';

                trigger OnAction()
                var
                    AADiscGrMgt: Codeunit "IMW Auto Assign Disc. Gr. Mgt.";

                begin
                    AADiscGrMgt.AutoAssingCustomerToDiscGroup(Rec);

                end;
            }
        }
        addlast(History)
        {
            action("History AA To Disc. Gr.")
            {
                Caption = 'History Of Auto Assign To Disc. Group';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Visible = AACustDiscGroupEnable;
                ToolTip = 'View History About Auto Assign To Discount Group.';
                RunObject = Page "IMW AA Disc. Gr. Hi. List";
                RunPageLink = "Customer No." = FIELD("No.");
            }
        }
    }

    var
        AACustDiscGroupEnable: Boolean;
        SetupStatus: Boolean;

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";

    begin
        SalesReceivablesSetup.Get();
        SetupStatus := false;
        if SalesReceivablesSetup."IMW AA Status" <> SalesReceivablesSetup."IMW AA Status"::Released then
            SetupStatus := true;
        AACustDiscGroupEnable := SalesReceivablesSetup."IMW AA Cust. Disc. Gr.";
    end;
}