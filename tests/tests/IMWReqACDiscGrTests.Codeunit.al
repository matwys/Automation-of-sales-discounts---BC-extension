codeunit 50101 "IMW Req. A. C. Disc. Gr. Tests"
{
    Subtype = Test;

    var
        LibraryRandom: Codeunit "Library - Random";
        LibraryUtility: Codeunit "Library - Utility";
        Assert: Codeunit Assert;
        IsInitialized: Boolean;
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibrarySetupStorage: cODEUNIT "Library - Setup Storage";

    [HandlerFunctions('ExpectedMessageHandler')]
    [Test]
    procedure "Given Some State_When Some Action_Then Expected Output"()
    var
        ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IMWReqAutoDiscGrList: TestPage "IMW Req. Auto Disc. Gr. List";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] In IMW Req. Auto. Cust. Disc. Gr. table only one record has value 0 in required field. Status is "Open".
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW Status" := SalesReceivablesSetup."IMW Status"::Open;
        SalesReceivablesSetup.Modify();
        // [WHEN] "Release" action is started in Requirements Auto Ass. Disc. Group page.
        IMWReqAutoDiscGrList.OpenEdit();
        IMWReqAutoDiscGrList."IMW Release".Invoke();
        // [THEN] Status is changed for "Released".
        SalesReceivablesSetup.Get();
        Assert.AreEqual(SalesReceivablesSetup."IMW Status"::Released, SalesReceivablesSetup."IMW Status", 'IMW Status is not changed for Released');
    end;

    [MessageHandler]
    procedure ExpectedMessageHandler(Msg: Text[1024])
    // Call the following in the Test function
    //   LibraryVariableStorage.Enqueue('ExpectedMessage');
    begin
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