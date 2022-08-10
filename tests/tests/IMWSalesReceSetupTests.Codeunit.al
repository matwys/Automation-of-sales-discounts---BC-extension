codeunit 50100 "IMW Sales & Rece. Setup Tests"
{
    Subtype = Test;

    var
        LibraryRandom: Codeunit "Library - Random";
        LibraryUtility: Codeunit "Library - Utility";
        Assert: Codeunit Assert;
        IsInitialized: Boolean;
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibrarySetupStorage: cODEUNIT "Library - Setup Storage";

    [HandlerFunctions('ExpectedConfirmHandlerFalse')]
    [Test]
    procedure CheckIfUserSelectNoFromConfirmWindow()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] On start value of Auto Assigned Cust. Disc. Group is true.
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();
        // [WHEN] Value of Auto Assigned Cust. Disc. is changed for false. Option "No" is selected from Confirm window. 
        SalesReceivablesSetup.Validate("IMW Auto Ass. Cust. Disc. Gr.", false);
        SalesReceivablesSetup.Modify();
        // [THEN] Value of Auto Assigned Cust. Disc. Group is true.
        Assert.AreEqual(true, SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr.", 'IMW Auto Ass. Cust. was changed.');

    end;

    [ConfirmHandler]
    procedure ExpectedConfirmHandlerFalse(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := false;
    end;

    local procedure Initialize();
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"IMW Sales & Rece. Setup Tests");
        ClearLastError();
        LibraryVariableStorage.Clear();
        LibrarySetupStorage.Restore();
        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"IMW Sales & Rece. Setup Tests");

        LibraryRandom.Init();

        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions


        IsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //   LibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"IMW Sales & Rece. Setup Tests");
    end;
}