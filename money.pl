% Facts
% Property values in EUR
property(jablonka_plots, 90206.00).         % Plots in Jablonka (9913, 9914, 9915)
property(jablonka_house_half, 227815.00).   % Half of the house in Jablonka (3873)
property(kasinka_full, 144089.09). %Full of Kasinka including Anna/Magda
property(kasinka_mala_5_8, 90055.7).       % 5/8 share of property in Kasinka Mala - Wojtek (9466)
property(kasinka_mala_3_8, 54033.4). % 3/8 share of property in Kasinka Mala - Magda/Anna
property(forest, 161000.00).                % Forest
property(krakow_apartment, 149500.00).      % Paulina's apartment in Krakow

% Allocated properties
allocation(paulina, krakow_apartment, 149500.00).   % Paulina's share - Krakow apartment
allocation(wojtek, kasinka_mala_5_8, 90055.7).    % Wojtek's share - full 5/8 of Kasinka Mala
allocation(wojtek, jablonka_plots_half, 45103.00). % Wojtek's share - half of the plots in Jablonka
allocation(alicja, jablonka_plots_half, 45103.00). % Alicja's share - half of the plots in Jablonka

% Surveyor and legal costs in EUR
surveyor_cost(sobieskiego_report, 345.00, 5). % Report for Sobieskiego (house in Jablonka)
surveyor_cost(magurska_report, 184.00, 5).    % Report for Magurska (plots in Jablonka)
surveyor_cost(kasinka_report, 345.00, 6).     % Report for Kasinka (property)

% Costs paid by heirs in EUR
cost_paid(adam, surveyor, 874.00).    % Adam covered all surveyor costs
cost_paid(adam, legal, 9200.00).      % Adam covered legal costs

% Lawyer's honorarium
lawyer_fee(9200.00).  % Temporary value in EUR

% Court costs
court_costs(1380.00). % Temporary value in EUR

% Sum of already allocated properties for a person
sum_allocated_properties(Person, SumAllocated) :-
    findall(AllocatedAmount, allocation(Person, _, AllocatedAmount), AllocatedAmounts),
    sum_list(AllocatedAmounts, SumAllocated).

% Total inheritance value
total_inheritance_value(TotalInheritance) :-
    property(jablonka_plots, P1),
    property(jablonka_house_half, P2),
    property(kasinka_mala_5_8, P3),
    property(forest, P4),
    property(krakow_apartment, P5),
    TotalInheritance is P1 + P2 + P3 + P4 + P5.

% Initial share of the inheritance (1/5 of the total value)
initial_share(_, Share) :-
    property(jablonka_plots, P1),
    property(jablonka_house_half, P2),
    property(kasinka_mala_5_8, P3),
    property(forest, P4),
    property(krakow_apartment, P5),
    Total is P1 + P2 + P3 + P4 + P5,
    Share is Total / 5.

% Total surveyor costs per person
surveyor_cost_per_person(CostPerPerson) :-
    surveyor_cost(sobieskiego_report, P1, _),
    surveyor_cost(magurska_report, P2, _),
    surveyor_cost(kasinka_report, P3, _),
    TotalCost is P1 + P2 + P3,
    CostPerPerson is TotalCost / 5.

% Legal costs per person
legal_cost_per_person(CostPerPerson) :-
    lawyer_fee(LawyerFee),
    court_costs(CourtCosts),
    TotalLegalCosts is LawyerFee + CourtCosts,
    CostPerPerson is TotalLegalCosts / 5.

% Total costs covered by a person
total_costs_covered_by(Person, TotalCostsCovered) :-
    findall(Amount, cost_paid(Person, _, Amount), CoveredCosts),
    sum_list(CoveredCosts, TotalCostsCovered).

% Adjusted share of the inheritance for a person
adjusted_share(Person, AdjustedShare) :-
    initial_share(Person, InitialShare),
    sum_allocated_properties(Person, AllocatedSum),
    surveyor_cost_per_person(SurveyorCostPerPerson),
    legal_cost_per_person(LegalCostPerPerson),
    total_costs_covered_by(Person, CoveredCostsByPerson),
    AdjustedShare is InitialShare
                  - AllocatedSum
                  - SurveyorCostPerPerson
                  - LegalCostPerPerson
                  + CoveredCostsByPerson.

% Predefined queries
:- total_inheritance_value(TotalInheritance),
   format("Total inheritance value: ~2f EUR~n", [TotalInheritance]),

   adjusted_share(adam, AdjustedShareAdam),
   format("Adam's share: ~2f EUR~n", [AdjustedShareAdam]),

   adjusted_share(paulina, AdjustedSharePaulina),
   format("Paulina's share: ~2f EUR~n", [AdjustedSharePaulina]),

   adjusted_share(wojtek, AdjustedShareWojtek),
   format("Wojtek's share: ~2f EUR~n", [AdjustedShareWojtek]),

   adjusted_share(alicja, AdjustedShareAlicja),
   format("Alicja's share: ~2f EUR~n", [AdjustedShareAlicja]),

   adjusted_share(janusz, AdjustedShareJanusz),
   format("Janusz's share: ~2f EUR~n", [AdjustedShareJanusz]),

   halt.
