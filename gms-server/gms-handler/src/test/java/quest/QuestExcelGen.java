package quest;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.gms.provider.Data;
import org.gms.provider.DataTool;
import org.gms.provider.wz.XMLWZFile;
import org.gms.util.PathUtils;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

/**
 * 生成任务excel记录
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/15 12:24
 */
public class QuestExcelGen {

    public static void main(String[] args) {
        // ---- 您原有的解析代码 ----
        Path enPath = Path.of("E:\\game\\ms\\gms053\\server\\gms53-Server\\gms-server\\gms-handler\\wz-zh-CN\\Quest.wz");
        XMLWZFile xmlwzFile = new XMLWZFile(enPath);
        Data questInfoData = xmlwzFile.getData("QuestInfo.img");
        Map<Integer, String> questNames = new HashMap<>();

        for (Data quest : questInfoData.getChildren()) {
            int questID = Integer.parseInt(quest.getName());
            Data reqInfo = questInfoData.getChildByPath(quest.getName());
            if (reqInfo != null) {
                String name = DataTool.getString("name", reqInfo, "");
                questNames.put(questID, name);
            }
        }
        System.out.println("解析完成，开始生成 Excel...");

        // ---- 生成 Excel 代码 ----
        Path root = PathUtils.getRootPath("bms");

        exportQuestToExcel(questNames, root + "\\Quest_log_Record.xlsx");
    }

    /**
     * 导出 Quest 修复记录表（按千位分隔为 6 个 Tab）
     *
     * @param questNames 包含解析出的 questId 和 questName 的 Map
     * @param outputPath 保存 Excel 的文件路径
     */
    public static void exportQuestToExcel(Map<Integer, String> questNames, String outputPath) {
        // 创建工作簿
        try (Workbook workbook = new XSSFWorkbook()) {

            // 1. 创建表头样式
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            // 居中对齐样式
            CellStyle centerStyle = workbook.createCellStyle();
            centerStyle.setAlignment(HorizontalAlignment.CENTER);
            centerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            String[] headers = {"任务 ID", "任务名", "是否已校验", "备注"};

            // 2. 循环生成 6 个 Tab (4000-4999 到 9000-9999)
            for (int start = 4000; start < 10000; start += 1000) {
                int end = start + 999;
                String sheetName = start + "-" + end;

                Sheet sheet = workbook.createSheet(sheetName);

                // 显示网格线
                sheet.setDisplayGridlines(true);

                // 写入表头
                Row headerRow = sheet.createRow(0);
                for (int i = 0; i < headers.length; i++) {
                    Cell cell = headerRow.createCell(i);
                    cell.setCellValue(headers[i]);
                    cell.setCellStyle(headerStyle);
                }

                // 写入当前千位段的数据
                int rowIndex = 1;
                for (int questId = start; questId <= end; questId++) {
                    Row row = sheet.createRow(rowIndex++);

                    // 第一栏：questId
                    Cell cellId = row.createCell(0);
                    cellId.setCellValue(questId);
                    cellId.setCellStyle(centerStyle);

                    if (questNames.containsKey(questId)) {
                        // Map 中有数据
                        String questName = questNames.get(questId);

                        // 第二栏：questName
                        row.createCell(1).setCellValue(questName);
                        // 第三栏：是否校验
                        row.createCell(2).setCellValue("");
                        // 第四栏：备注
                        row.createCell(3).setCellValue("");
                    } else {
                        // Map 中未找到的数据
                        // 第二栏：name 不显示 (留空)
                        row.createCell(1).setCellValue("");
                        // 第三栏：是否校验
                        row.createCell(2).setCellValue("");
                        // 第四栏：备注写“未找到”
                        Cell cellRemark = row.createCell(3);
                        cellRemark.setCellValue("未找到");
                        cellRemark.setCellStyle(centerStyle);
                    }
                }

                // 自动调整列宽
                int mixWidth = 30 * 256;
                for (int i = 0; i < headers.length; i++) {
                    sheet.autoSizeColumn(i);
                    if (sheet.getColumnWidth(i) < mixWidth) {
                        sheet.setColumnWidth(i, mixWidth);
                    }
                }
            }

            // 3. 保存文件到本地
            try (FileOutputStream fos = new FileOutputStream(outputPath)) {
                workbook.write(fos);
                System.out.println("Excel 导出成功！保存路径为: " + outputPath);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}