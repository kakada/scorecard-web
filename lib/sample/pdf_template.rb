# frozen_string_literal: true

module Sample
  class PdfTemplate
    def self.load
      program = ::Program.find_by name: "CARE"

      program.pdf_templates.create(
        name: "SWOT result",
        language_code: "km",
        content: '<div style="text-align: center;"><div><div><span style="font-size: 24px;"><font face="Battambang_Bold">ព្រះរាជាណាចក្រកម្ពុជា</font></span></div><div><span style="text-align: left; font-size: 24px;"><font face="Battambang_Bold">ជាតិ សាសនា ព្រះមហាក្សត្រ</font></span></div><div style="text-align: left;"><br></div><div style="text-align: left;"><br></div><div style="text-align: left;">ខេត្ត.......{{scorecard.province}}<br></div><div style="text-align: left;"><div>ស្រុក/ក្រុង .......{{scorecard.district}}</div><div>ឃុំ.......{{scorecard.commune}}</div></div><div style="text-align: left;"><br></div><div>លទ្ទផលបណ្ណ័ដាក់ពិន្ទុសហគមន៍ / លទ្ធផលការវាយតម្លៃខ្លួនឯងដោយអ្នកផ្តល់សេវា<br></div><div>ភូមិ/ទីកន្លែង&nbsp;<span style="font-size: 1rem;">.......</span><span style="font-size: 1rem;">..........វិស័យ/ក្រុម៖…{{scorecard.facility_name}}…កាលបរិច្ឆេទ៖…{{scorecard.conducted_date}}…</span></div><div style="text-align: left;"><br></div><div style="text-align: left;">{{swot.result_table}}</div><div style="text-align: left;"><span style="font-size: 1rem; text-align: right;"><br></span></div><div style="text-align: left;"><span style="font-size: 1rem; text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</span></div><div style="text-align: left;"><span style="font-size: 1rem;"><table class="table-1 table border-0"><tbody><tr><td style="padding-right: 80px;" class="border-0">ចម្លងជូន៖ <br><ul><li>មណ្ឌលសុខភាព<br></li><li>សាលាបឋមសិក្សា</li><li>អាជ្ញាធរពាក់ព័ន្ធ<br></li></ul><br></td><td class="border-0">អនុវត្តដោយអង្គការ..{{scorecard.local_ngo_name}}... <br>ចម្លងចេញថ្ងៃទី..........ខែ..........ឆ្នាំ...........<br>រៀបចំដោយអ្នកសម្របសម្រួលគណនេយ្យភាពឃុំ.....{{scorecard.commune}}.......<br><div><span style="font-size: 1rem;">{{scorecard.facilitators}}</span></div></td><td class="border-0"><div style="text-align: right;">បានឃើញ/ទទួលថ្ងៃទី............ខែ............ឆ្នាំ ជូត ទោស័ក ព.ស. ២៥៦៤<br></div><div style="text-align: right;"><br></div><div style="text-align: right;">ឈ្មោះឃុំ...............ថ្ងៃទី............ខែ............ឆ្នាំ ២០២១<br></div><div style="text-align: right;">មេឃុំ&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div></td></tr></tbody></table></span></div></div></div>'
      )
    end
  end
end
