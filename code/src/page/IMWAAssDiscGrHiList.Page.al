page 50002 "IMW A. Ass. Disc. Gr. Hi. List"
{
    ApplicationArea = All;
    Caption = 'Auto Assing To Cust. Disc. Gr. Hist.';
    PageType = List;
    SourceTable = "IMW Auto. Ass. Disc. Gr. Hist.";
    UsageCategory = Lists;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(History)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                    ToolTip = 'No.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    ToolTip = 'Customer No.';
                }
                field("Cust. Disc. Group Code"; Rec."Cust. Disc. Group Code")
                {
                    Caption = 'Cust. Disc. Group Code';
                    ApplicationArea = All;
                    ToolTip = 'Cust. Disc. Group Code';
                }
                field("IMW Last Auto. Ass. Ch. By"; Rec."IMW Last Auto. Ass. Ch. By")
                {
                    Caption = 'Last Auto Assign Changed By';
                    ApplicationArea = All;
                    ToolTip = 'Last Auto Assign Changed By';
                }
                field("IMW Last Auto Ass. Ch. Date"; Rec."IMW Last Auto Ass. Ch. Date")
                {
                    Caption = 'Last Auto Assign Changed Date';
                    ApplicationArea = All;
                    ToolTip = 'Last Date Of Auto Assigned To Discount Group';
                }
            }
        }
    }
}