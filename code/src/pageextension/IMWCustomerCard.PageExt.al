pageextension 50002 "IMW Customer Card" extends "Customer Card"
{
    layout
    {
        modify("Customer Disc. Group")
        {
            Editable = NOT CDGAEnabled;
        }
        addafter("Customer Disc. Group")
        {
            field("IMW CDGA Valid To"; Rec."IMW CDGA Valid To")
            {
                Caption = 'CDGA Valid To';
                ApplicationArea = All;
                ToolTip = 'CDGA Valid To';
                Editable = false;
                Visible = CDGAEnabled;
            }
            field("IMW CDGA Changed By"; Rec."IMW CDGA Changed By")
            {
                Caption = 'CDGA Changed By';
                ApplicationArea = All;
                ToolTip = 'Last CDGA Changed By';
                Editable = false;
                Visible = CDGAEnabled;
            }
            field("IMW CDGA Changed Date"; Rec."IMW CDGA Changed Date")
            {
                Caption = 'CDGA Changed Date';
                ApplicationArea = All;
                ToolTip = 'Last CDGA Changed Date';
                Editable = false;
                Visible = CDGAEnabled;
            }
        }
    }

    actions
    {
        addlast("Prices and Discounts")
        {
            action("IMW CDGA Update Customer")
            {
                Caption = 'CDGA Update Customer';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Enabled = not CDGAThresholdSetupStatus;
                Visible = CDGAEnabled;
                ToolTip = 'CDGA Update Customer.';

                trigger OnAction()
                var
                    IMWAACustDiscGrMgt: Codeunit "IMW CDGA Mgt.";
                begin
                    IMWAACustDiscGrMgt.AutoAssignCustomerToDiscGroup(Rec);

                end;
            }
        }
        addlast(History)
        {
            action("IMW CDGA Change Log")
            {
                Caption = 'CDGA Change Log';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Visible = CDGAEnabled;
                ToolTip = 'View Log About CDGA';
                RunObject = Page "IMW CDGA Change Log";
                RunPageLink = "Customer No." = FIELD("No.");
            }
        }
    }

    var
        CDGAEnabled: Boolean;
        CDGAThresholdSetupStatus: Boolean;

    trigger OnOpenPage()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        CDGAThresholdSetupStatus := false;
        if SalesReceivablesSetup."IMW CDGA Treshold Setup Status" <> SalesReceivablesSetup."IMW CDGA Treshold Setup Status"::Released then
            CDGAThresholdSetupStatus := true;
        CDGAEnabled := SalesReceivablesSetup."IMW CDGA Enabled";
    end;
}