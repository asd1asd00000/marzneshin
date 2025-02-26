
---

### چطور کار می‌کنه؟
1. **نمایش توی گیت‌هاب**:
   - هر بلوک کد (```bash ... ```) به صورت جداگانه توی صفحه مخزن نشون داده میشه.
   - بالای هر بلوک کد، یه آیکون کپی (یک مستطیل کوچک) ظاهر میشه که با کلیک روش، فقط محتوای همون بلوک کپی میشه.

2. **مزایا**:
   - کاربرا می‌تونن به راحتی هر کد رو جداگانه کپی کنن بدون اینکه نیاز باشه چیزی رو دستی انتخاب کنن.
   - توضیحات بالای هر کد مشخص می‌کنه که اون کد برای چیه.

3. **اجرا**:
   - کاربر کدی که کپی کرده رو توی ترمینالش Paste می‌کنه و اجرا می‌کنه.

---

### اگه بخوای حرفه‌ای‌تر باشه
اگه مخزن رو عمومی می‌کنی و می‌خوای ظاهر بهتری داشته باشه، می‌تونی از HTML توی `README.md` استفاده کنی یا از ابزارهایی مثل Shields.io برای اضافه کردن بج (Badge) استفاده کنی. مثلاً:

```markdown
# Marznode Setup Scripts

## اسکریپت‌ها

<div>
<strong>نصب اصلی:</strong>
<pre><code>sudo bash -c "$(curl -sL https://raw.githubusercontent.com/erfjab/MarznodeSetup/master/setup_marznode.sh)"</code></pre>
</div>

<div>
<strong>آپدیت تنظیمات:</strong>
<pre><code>sudo bash -c "$(curl -sL https://raw.githubusercontent.com/erfjab/MarznodeSetup/master/update_config.sh)"</code></pre>
</div>

<div>
<strong>حذف نصب:</strong>
<pre><code>sudo bash -c "$(curl -sL https://raw.githubusercontent.com/erfjab/MarznodeSetup/master/uninstall.sh)"</code></pre>
</div>
