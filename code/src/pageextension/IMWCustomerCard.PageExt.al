pageextension 50002 "IMW Customer Card" extends "Customer Card"
{
    layout
    {
        modify("Customer Disc. Group")
        {
            Editable = NOT CDGAEnabledIsEnabled;
        }
        addafter("Customer Disc. Group")
        {
            field("IMW CDGA Valid To"; Rec."IMW CDGA Valid To")
            {
                Caption = 'CDGA Valid To';
                ApplicationArea = All;
                ToolTip = 'CDGA Valid To';
                Editable = false;
                Visible = CDGAEnabledIsEnabled;
            }
            field("IMW CDGA Changed By"; Rec."IMW CDGA Changed By")
            {
                Caption = 'CDGA Changed By';
                ApplicationArea = All;
                ToolTip = 'Last CDGA Changed By';
                Editable = false;
                Visible = CDGAEnabledIsEnabled;
            }
            field("IMW CDGA Changed Date"; Rec."IMW CDGA Changed Date")
            {
                Caption = 'CDGA Changed Date';
                ApplicationArea = All;
                ToolTip = 'Last CDGA Changed Date';
                Editable = false;
                Visible = CDGAEnabledIsEnabled;
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
                Enabled = CDGAThresholdSetupStatusIsReleased;
                Visible = CDGAEnabledIsEnabled;
                ToolTip = 'CDGA Update Customer.';

                trigger OnAction()
                var
                    IMWAACustDiscGrMgt: Codeunit "IMW CDGA Mgt.";
                begin
                    IMWAACustDiscGrMgt.AutoAssignCustomerToDiscGroup(Rec);
                    Message(CDGAUpdateCustomerMsg);
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
                Visible = CDGAEnabledIsEnabled;
                ToolTip = 'View Log About CDGA';
                RunObject = Page "IMW CDGA Change Log";
                RunPageLink = "Customer No." = FIELD("No.");
            }
        }
    }

    var
        CDGAEnabledIsEnabled: Boolean;
        CDGAThresholdSetupStatusIsReleased: Boolean;
        CDGAUpdateCustomerMsg: Label 'Assign to Customer Disc. Group has been correctly updated.';

    trigger OnOpenPage()
    var
        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
    begin
        CDGAThresholdSetupStatusIsReleased := IMWCDGAMgt.CheckCDGAThresholdSetupStatusIsRelease();
        CDGAEnabledIsEnabled := IMWCDGAMgt.CheckCDGAEnabledIsEnabled();
    end;
}