import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';

final List<ProcessModel> propertyProcesses = [
  ProcessModel(
    id: 'property_registry',
    categoryId: 'property',
    title: 'Property Registry (Sale Deed)',
    summary: 'Register the sale of a house or plot in the buyer name.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Sale deed', copies: 2),
      DocumentItemModel(
        id: 'd2',
        title: 'CNIC of buyer and seller',
        copies: 2,
        attestationRequired: true,
      ),
      DocumentItemModel(id: 'd3', title: 'Latest Fard (record of rights) and property tax receipts', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'Sub Registrar Office',
      cityAddresses: {},
      timings: 'Mon to Fri, 9am to 2pm',
    ),
    fee: const FeeInfo(
      tiers: [
        FeeTier('Stamp duty', '1% of DC rate value'),
        FeeTier('Capital Value Tax (CVT)', '2% of DC rate value'),
        FeeTier('Registration fee', '1% of DC rate value'),
        FeeTier('FBR advance tax 236K, filer buyer', '1.5%'),
        FeeTier('PLRA charges', 'About Rs. 3,300'),
        FeeTier('Comparison fee', 'About Rs. 5,100'),
      ],
      notes: 'Percentages are on the DC rate valuation and change with your filer status. Confirm current rates with the Sub Registrar before paying.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Submit the sale deed and CNIC copies for verification.',
        'Pay stamp duty, CVT and the registration fee.',
        'Buyer and seller complete biometric verification.',
      ],
      receiptNote: 'Keep the registration receipt, you need it whenever you sell.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Around 15 to 20 working days',
      followUp: 'After registration, get the mutation (intkal) done separately.',
    ),
    source: SourceInfo(
      sourceName: 'Punjab property registry cost guide (PLRA and FBR rates)',
      url: 'https://arzaaypak.com/total-property-registry-cost-punjab-2026/',
      lastVerified: DateTime(2026, 1, 27),
    ),
  ),
  ProcessModel(
    id: 'property_mutation',
    categoryId: 'property',
    title: 'Property Mutation (Intkal)',
    summary: 'Update the revenue record after the registry.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Registered sale deed', copies: 1),
      DocumentItemModel(id: 'd2', title: 'CNIC copy', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'Land Record Center (Arazi Record Center)',
      cityAddresses: {},
      timings: 'Mon to Fri, 9am to 2pm',
    ),
    fee: const FeeInfo(
      tiers: [FeeTier('Mutation fee', 'About 0.5% of property value')],
      notes: 'Rate is quoted by a Pakistan property guide. Confirm the exact amount at the land record center.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Apply for mutation with the registered deed.',
        'Pay the fee.',
        'The record is updated in your name.',
      ],
      receiptNote: 'Get an updated Fard once mutation is done.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'A few days to two weeks',
      followUp: 'Collect your updated Fard.',
    ),
    source: SourceInfo(
      sourceName: 'Pakistan stamp duty and registration guide',
      url: 'https://tools.realestate/s/pakistan/general/pakistan-stamp-duty',
      lastVerified: DateTime(2026, 2, 26),
    ),
  ),
];
