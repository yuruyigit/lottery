package com.npc.lottery.job.common.gdklsf;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.collections.MapUtils;
import org.apache.log4j.Logger;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.npc.lottery.common.Constant;
import com.npc.lottery.common.service.ShopSchemeService;
import com.npc.lottery.member.logic.interf.ILotteryResultLogic;
import com.npc.lottery.monitoring.entity.MonitoringInfo;
import com.npc.lottery.monitoring.logic.interf.IMonitoringInfoLogic;
import com.npc.lottery.periods.entity.GDPeriodsInfo;
import com.npc.lottery.periods.logic.interf.IGDPeriodsInfoLogic;

public class GDReLotteryEOD extends QuartzJobBean {

	private static final Logger logger = Logger.getLogger(GDReLotteryEOD.class);
	@Autowired
	private IGDPeriodsInfoLogic gdPeriodsInfoLogic;
	@Autowired
	private ILotteryResultLogic lotteryResultLogic;
	@Autowired
	private ShopSchemeService shopSchemeService;
	@Autowired
	private IMonitoringInfoLogic monitoringInfoLogic;

	@Override
	protected void executeInternal(JobExecutionContext arg0) throws JobExecutionException {
		logger.info("广东 快乐十分  对投注表遗漏数据重新兑奖>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>开始");

		// 获取商铺对应的scheme列表
		Map<String, String> shopSchemeMap = shopSchemeService.getShopSchemeMap();

		// 每一个商铺按每期进去兑奖
		for (Entry<String, String> shopScheme : shopSchemeMap.entrySet()) {
			long startTime = System.currentTimeMillis();
			String scheme = shopScheme.getValue();
			String shopCode = shopScheme.getKey();
			try {
				// 获取盘期表里已兑奖或开奖,但投注表里遗漏兑奖的盘期列表,key=盘期,value=盘期对象
				Map<String, GDPeriodsInfo> periodsInfoMap = gdPeriodsInfoLogic.getPeriodsInfoFromBetTableForReLotteryEOD(scheme);

				if (MapUtils.isNotEmpty(periodsInfoMap)) {

					// 如果获取的盘期列表，投注表里有没有兑奖的数据，执行该期重新兑奖的操作
					for (Map.Entry<String, GDPeriodsInfo> entry : periodsInfoMap.entrySet()) {
						GDPeriodsInfo periodsInfo = entry.getValue();
						logger.info("广东 快乐十分  对投注表遗漏数据重新兑奖>>>>>>>>>>盘期：" + periodsInfo.getPeriodsNum());
						List<Integer> numsList = new ArrayList<Integer>();
						numsList.add(periodsInfo.getResult1());
						numsList.add(periodsInfo.getResult2());
						numsList.add(periodsInfo.getResult3());
						numsList.add(periodsInfo.getResult4());
						numsList.add(periodsInfo.getResult5());
						numsList.add(periodsInfo.getResult6());
						numsList.add(periodsInfo.getResult7());
						numsList.add(periodsInfo.getResult8());
						long star = System.currentTimeMillis();
						try {
							lotteryResultLogic.updatePlayTypeWin(periodsInfo.getPeriodsNum(), numsList, Constant.LOTTERY_TYPE_GDKLSF);
							lotteryResultLogic.updateGDForReLottery(periodsInfo.getPeriodsNum(), numsList, periodsInfo.getOpenQuotTime(), scheme);

							monitoringInfoLogic.saveMonitoringInfo(new MonitoringInfo(0, "GDKLF", shopScheme.getKey(), periodsInfo.getPeriodsNum(), "重新兑奖", 1, "商铺：" + shopScheme.getKey() + "的广东 快乐十分"
							        + periodsInfo.getPeriodsNum() + "盘期重新兑奖", (int) (System.currentTimeMillis() - star)));

							// 3.计算统计报表
							long startReport = System.currentTimeMillis();
							boolean flag = lotteryResultLogic.saveReportPeriod(periodsInfo.getPeriodsNum(), Constant.LOTTERY_TYPE_GDKLSF, scheme);// 统计报表
							if (flag) {
								monitoringInfoLogic.saveMonitoringInfo(new MonitoringInfo(0, "GDKLF", shopCode, periodsInfo.getPeriodsNum(), "报表计算", 1, "商铺：" + shopCode + "广东盘期"
								        + periodsInfo.getPeriodsNum() + "报表计算", (int) (System.currentTimeMillis() - startReport)));
							} else {
								monitoringInfoLogic.saveMonitoringInfo(new MonitoringInfo(0, "GDKLF", shopCode, periodsInfo.getPeriodsNum(), "报表计算", 0, "商铺：" + shopCode + "广东盘期"
								        + periodsInfo.getPeriodsNum() + "报表计算", (int) (System.currentTimeMillis() - startReport)));
							}
						} catch (Exception ex) {
							monitoringInfoLogic.saveMonitoringInfo(new MonitoringInfo(0, "GDKLF", shopScheme.getKey(), periodsInfo.getPeriodsNum(), "重新兑奖", 0, "商铺：" + shopScheme.getKey() + "的广东 快乐十分"
							        + periodsInfo.getPeriodsNum() + "盘期重新兑奖", (int) (System.currentTimeMillis() - star)));
						}
					}
				} else {
					logger.info("广东 快乐十分  没有遗漏没有兑奖的数据在投注表");
				}
			} catch (Exception ex) {
				monitoringInfoLogic.saveMonitoringInfo(new MonitoringInfo(0, "GDKLF", shopCode, "0000000000", "重新兑奖", 0, "广东 快乐十分,商铺:" + shopCode + "重新兑奖异常",
				        (int) (System.currentTimeMillis() - startTime)));
			}
		}
	}
}
