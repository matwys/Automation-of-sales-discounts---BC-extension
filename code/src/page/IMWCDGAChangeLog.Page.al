page 50002 "IMW CDGA Change Log"
{
    ApplicationArea = All;
    Caption = 'CDGA Change Log';
    PageType = List;
    SourceTable = "IMW CDGA Change Log";
    UsageCategory = Lists;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(History)
            {
                Caption = 'History';
                field("Entry No."; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    ToolTip = 'Entry No.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    ToolTip = 'Customer No.';
                }
                field("Customer Disc. Group Code"; Rec."Customer Disc. Group Code")
                {
                    Caption = 'Customer Disc. Group Code';
                    ApplicationArea = All;
                    ToolTip = 'Customer Disc. Group Code';
                }
                //field("CDGA Changed By"; Rec."CDGA Changed By")
                field("CDGA Changed By"; Rec.SystemCreatedBy)
                {

                    Caption = 'CDGA Changed By';
                    ApplicationArea = All;
                    ToolTip = 'CDGA Changed By';
                }
                //field("CDGA Changed Date"; Rec."CDGA Changed Date")
                field("CDGA Changed Date"; Rec.SystemCreatedAt)
                {
                    Caption = 'CDGA Changed Date';
                    ApplicationArea = All;
                    ToolTip = 'CDGA Changed Date';
                }
            }
        }
    }
}