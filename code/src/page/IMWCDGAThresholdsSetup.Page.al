page 50001 "IMW CDGA Thresholds Setup"
{
    ApplicationArea = All;
    Caption = 'CDGA Thresholds Setup';
    PageType = List;
    SourceTable = "IMW CDGA Thresholds Setup";
    UsageCategory = Lists;
    DelayedInsert = true;


    layout
    {
        area(Content)
        {
            repeater(Groups)
            {
                Caption = 'Groups';
                field("Customer Disc. Group Code"; Rec."Cust. Disc. Group Code")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Disc. Gruop Code';
                    Editable = not CDGAThresholdSetupStatusIsReleased;
                    ToolTip = 'Specifies a code for the customer discount group.';
                }
                field("Threshold Sales Amount"; Rec."Threshold Sales Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Threshold Sales Amount (LCY)';
                    Editable = not CDGAThresholdSetupStatusIsReleased;
                    ToolTip = 'Specifies A Threshold Sales Amount (LCY) For The Customer Disc. Group.';
                }
                field("Threshold Entries Count"; Rec."Threshold Entries Count")
                {
                    ApplicationArea = All;
                    Caption = 'Threshold Entries Count';
                    Editable = not CDGAThresholdSetupStatusIsReleased;
                    ToolTip = 'Specifies A Threshold Entries Count For The Customer Disc. Group.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Release Group")
            {
                Caption = 'Release';
                action("Release")
                {
                    ApplicationArea = All;
                    Caption = 'Release';
                    Enabled = not CDGAThresholdSetupStatusIsReleased;
                    Image = ReleaseDoc;
                    ToolTip = 'Release the Requirements Auto-ass Disc. Group to the next stage of processing.';

                    trigger OnAction()
                    var
                        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
                    begin
                        IMWCDGAMgt.ChangeCDGATHresholdSetupStatusForReleased();
                        CurrPage.Update();

                        CDGAThresholdSetupStatusIsReleased := IMWCDGAMgt.CheckCDGAThresholdSetupStatusIsRelease();
                    end;
                }
                action("Open")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    Enabled = CDGAThresholdSetupStatusIsReleased;
                    Image = ReOpen;
                    ToolTip = 'Reopen the Requirements Auto Assign Disc. Group to change it after it has been approved.';

                    trigger OnAction()
                    var
                        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
                    begin
                        IMWCDGAMgt.ChangeCDGAThresholdSetupStatusForOpen();
                        CurrPage.Update();

                        CDGAThresholdSetupStatusIsReleased := IMWCDGAMgt.CheckCDGAThresholdSetupStatusIsRelease();
                    end;
                }
            }
            group("Report")
            {
                action("CDGA Update All Customers")
                {
                    ApplicationArea = All;
                    Caption = 'CDGA Update All Customers';
                    Enabled = CDGAThresholdSetupStatusIsReleased and CDGAEnabledIsEnabled;
                    Image = ReleaseDoc;
                    ToolTip = 'CDGA Update All Customers by Balance';

                    trigger OnAction()
                    var
                        IMWAutoAssCustDiscGr: Report "IMW CDGA Update All Cust.";
                    begin
                        IMWAutoAssCustDiscGr.Run();
                    end;
                }
            }
        }
    }
    var
        CDGAEnabledIsEnabled: Boolean;
        CDGAThresholdSetupStatusIsReleased: Boolean;

    trigger OnOpenPage()
    var
        IMWCDGAMgt: Codeunit "IMW CDGA Mgt.";
    begin
        CDGAThresholdSetupStatusIsReleased := IMWCDGAMgt.CheckCDGAThresholdSetupStatusIsRelease();
        CDGAEnabledIsEnabled := IMWCDGAMgt.CheckCDGAEnabledIsEnabled();
    end;
}