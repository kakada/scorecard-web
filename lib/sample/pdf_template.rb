# frozen_string_literal: true

module Sample
  class PdfTemplate
    def self.load
      program = ::Program.find_by name: "CARE"

      program.pdf_templates.create(
        name: "SWOT result",
        language_code: "km",
        content: "<div style=\"text-align: center;\"><span style=\"font-size: 24px;\"><font face=\"Battambang_Bold\">ព្រះរាជាណាចក្រកម្ពុជា</font></span></div><div style=\"text-align: center;\"><span style=\"text-align: left; font-size: 24px;\"><font face=\"Battambang_Bold\">ជាតិ សាសនា ព្រះមហាក្សត្រ</font></span></div><div><br></div><div><br></div><div>ខេត្ត.......{{scorecard_province}}<br></div><div><div>ស្រុក/ក្រុង .......{{scorecard_district}}</div><div>ឃុំ.......{{scorecard_commune}}</div></div><div><br></div><div style=\"text-align: center;\">លទ្ទផលបណ្ណ័ដាក់ពិន្ទុសហគមន៍ / លទ្ធផលការវាយតម្លៃខ្លួនឯងដោយអ្នកផ្តល់សេវា<br></div><div style=\"text-align: center;\">ភូមិ/ទីកន្លែង&nbsp;<span style=\"font-size: 1rem;\">.......</span><span style=\"font-size: 1rem;\">..........វិស័យ/ក្រុម៖…{{scorecard_facility_name}}…កាលបរិច្ឆេទ៖…{{scorecard_conducted_date}}…</span></div><div style=\"text-align: left;\"><br></div><div style=\"text-align: left;\">{{v_result_table}}</div><div><div style=\"text-align: right;\"><br></div></div><div style=\"text-align: right;\">ថ្ងៃ.......................ខែ.................ឆ្នាំ ជូត ទោស័ក ព.ស. ២៥៦៤<br></div><div style=\"text-align: right;\">ឈ្មោះឃុំ ថ្ងៃទី ................ខែ.................ឆ្នាំ ២០២១<br></div><div style=\"text-align: right;\">មេឃុំ&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div><div><span style=\"font-size: 1rem;\"><br></span></div><div><span style=\"font-size: 1rem;\">ចម្លងជូន៖</span></div><div><ul><li>មណ្ឌលសុខភាព</li><li>សាលាបឋមសិក្សា</li><li>អាជ្ញាធរពាក់ព័ន្ធ</li></ul></div>"
      )
    end
  end
end
