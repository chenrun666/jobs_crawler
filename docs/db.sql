create DATABASE IF NOT EXISTS `crawler` DEFAULT CHARACTER SET utf8mb4;

USE `crawler`;

CREATE TABLE IF NOT EXISTS `job_info` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` VARCHAR(31) NOT NULL DEFAULT '' COMMENT '职位名称',
  `company` VARCHAR(15) NOT NULL DEFAULT '' COMMENT '公司',
  `city` VARCHAR(15) NOT NULL DEFAULT '' COMMENT '所在城市',
  `salary` VARCHAR(15) NOT NULL DEFAULT '' COMMENT '薪资',
  `education` VARCHAR(15) NOT NULL DEFAULT '' COMMENT '学历要求',
  `work_exp` VARCHAR(15) NOT NULL DEFAULT '' COMMENT '工作年限要求',
  `jd` VARCHAR(2046) NOT NULL DEFAULT '' COMMENT '职位描述',
  `wlfare` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '福利',
  `url` VARCHAR(127) NOT NULL DEFAULT '' COMMENT '职位详细URL',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COMMENT='职位信息表';

CREATE TABLE IF NOT EXISTS `crawl_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain` VARCHAR(31) NOT NULL DEFAULT '' COMMENT '来源域名 (不一定是顶级域名)',
  `name` VARCHAR(31) NOT NULL DEFAULT '' COMMENT '来源名称',
  `job_name` VARCHAR(127) NOT NULL DEFAULT '' COMMENT '职位名称规则',
  `job_company` VARCHAR(127) NOT NULL DEFAULT '' COMMENT '职位公司规则',
  `job_city` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '职位所在城市规则',
  `job_work_exp` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '职位工作年限要求',
  `job_salary` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '职位薪资规则',
  `job_education` VARCHAR(127) NOT NULL DEFAULT '' COMMENT '职位学历规则',
  `job_jd` VARCHAR(127) NOT NULL DEFAULT '' COMMENT '职位 JD 规则',
  `job_welfare` VARCHAR(127) NOT NULL DEFAULT '' COMMENT '职位福利规则',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='网站抓取规则表';

CREATE TABLE IF NOT EXISTS `auto_crawl_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain` VARCHAR(31) NOT NULL DEFAULT '' COMMENT '来源域名 (不一定是顶级域名)',
  `all_url` VARCHAR(127) NOT NULL DEFAULT '' COMMENT '全量url, 关键词占位符使用%s',
  `incr_url` VARCHAR(127) NOT NULL DEFAULT '' COMMENT '增量url, 关键词占位符使用%s',
  `keywords` VARCHAR(63) NOT NULL DEFAULT '' COMMENT '搜索关键词, 多个逗号分隔',
  `list_selector` VARCHAR(31) NOT NULL DEFAULT '' COMMENT '列表选择器',
  `result_selector` VARCHAR(31) NOT NULL DEFAULT '' COMMENT '结果选择器, 获取具体职位的URL',
  `page_field` VARCHAR(20) NOT NULL DEFAULT '' COMMENT '分页字段名',
  `max_page` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '全量最多抓取多少页',
  `ext` VARCHAR(1023) NOT NULL DEFAULT '' COMMENT '扩展信息, 某些网站特殊配置, json格式',
  `state` TINYINT(3) NOT NULL DEFAULT '0' COMMENT '状态: 0-自动抓取; 1-停止抓取',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY (`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='网站自动抓取规则表';



INSERT INTO `auto_crawl_rule` (`domain`, `all_url`, `incr_url`, `keywords`, `list_selector`, `result_selector`, `page_field`, `max_page`, `ext`, `state`)
VALUES ('www.zhipin.com', 'https://www.zhipin.com/job_detail/?query=%s&city=100010000', 'https://www.zhipin.com/job_detail/?query=%s&city=100010000', 'golang,go语言', '.job-list .job-primary', '.info-primary .name a', 'page', 5, '', 0);

INSERT INTO `crawl_rule` (`domain`, `name`, `job_name`, `job_company`, `job_city`, `job_work_exp`, `job_salary`, `job_education`, `job_jd`, `job_welfare`)
VALUES ('www.zhipin.com', 'Boss直聘', '.info-primary .name h1', '.sider-company .company-info a[ka=job-detail-company_custompage]', '<p>([^<]*)<em class=\"dolt\"', '<p>[^<]*<em .*</em>([^<]*)<em .*</em>', '.info-primary .salary', '<p>[^<]*<em .*</em>[^<]*<em .*</em>([^<]*)</p>', '.detail-content .job-sec:first-child', '.info-primary .tag-container .tag-all');
