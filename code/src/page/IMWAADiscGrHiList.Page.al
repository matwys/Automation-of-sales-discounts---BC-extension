page 50002 "IMW AA Disc. Gr. Hi. List"
{
    ApplicationArea = All;
    Caption = 'Auto Assign Customer To Disc. Group History';
    PageType = List;
    SourceTable = "IMW AA To Disc. Gr. Hist.";
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
                field("No."; Rec."No.")
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
                field("IMW Last AA Ch. By"; Rec."IMW Last AA Ch. By")
                {
                    Caption = 'Last Auto Assign To Disc. Group Changed By';
                    ApplicationArea = All;
                    ToolTip = 'Last Auto Assign To Discount Group Changed By';
                }
                field("IMW Last AA Ch. Date"; Rec."IMW Last AA Ch. Date")
                {
                    Caption = 'Last Auto Assign To Disc. Group Changed Date';
                    ApplicationArea = All;
                    ToolTip = 'Last Date Of Auto Assigned To Discount Group Changed';
                }
            }
        }
    }
}